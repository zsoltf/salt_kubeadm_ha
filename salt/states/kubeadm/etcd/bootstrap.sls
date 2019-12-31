{% set cluster_mine = salt['mine.get']('kube:role:etcd', 'ip', 'grain') | dictsort() %}
{% set cluster = [] %}
{% for name, host in cluster_mine %}
  {% do cluster.append(name ~ "=https://" ~ host[0] ~ ":2380") %}
{% endfor %}


kubeadm-etcd-generate-ca:
  cmd.run:
    - name: kubeadm init phase certs etcd-ca
    - creates:
        - /etc/kubernetes/pki/etcd/ca.crt
        - /etc/kubernetes/pki/etcd/ca.key


{% for name, host in cluster_mine %}

kubeadm-deploy-dir-{{ name }}:
  file.directory:
    - name: /deploy/{{ name }}/pki/etcd
    - makedirs: True

kubeadm-config-{{ name }}:
  file.managed:
    - name: /deploy/{{ name }}/kubeadm-etcd.yaml
    - contents: |
        apiVersion: "kubeadm.k8s.io/v1beta2"
        kind: ClusterConfiguration
        etcd:
          local:
            serverCertSANs:
              - "{{ host[0] }}"
            peerCertSANs:
              - "{{ host[0] }}"
            extraArgs:
                initial-cluster: {{ cluster|join(",") }}
                initial-cluster-state: new
                name: {{ name }}
                listen-peer-urls: https://{{ host[0] }}:2380
                listen-client-urls: https://{{ host[0] }}:2379
                advertise-client-urls: https://{{ host[0] }}:2379
                initial-advertise-peer-urls: https://{{ host[0] }}:2380
    - require:
        - file: kubeadm-deploy-dir-{{ name }}
        - cmd: kubeadm-etcd-generate-ca

kubeadm-etcd-generate-server-certs-{{ name }}:
  cmd.run:
    - name: |
        kubeadm init phase certs etcd-server --config=/deploy/{{ name }}/kubeadm-etcd.yaml && \
        kubeadm init phase certs etcd-peer --config=/deploy/{{ name }}/kubeadm-etcd.yaml && \
        kubeadm init phase certs etcd-healthcheck-client --config=/deploy/{{ name }}/kubeadm-etcd.yaml && \
        kubeadm init phase certs apiserver-etcd-client --config=/deploy/{{ name }}/kubeadm-etcd.yaml && \
        find /etc/kubernetes/pki/etcd -type f -not -name ca.key -not -name ca.crt -exec mv {} /deploy/{{ name }}/pki/etcd \; && \
        mv /etc/kubernetes/pki/apiserver-etcd-client.* /deploy/{{ name }}/pki/ && \
        cp /etc/kubernetes/pki/etcd/ca.crt /deploy/{{ name }}/pki/etcd/
    - creates:
        - /deploy/{{ name }}/pki/apiserver-etcd-client.crt
        - /deploy/{{ name }}/pki/apiserver-etcd-client.key
        - /deploy/{{ name }}/pki/etcd/ca.crt
        - /deploy/{{ name }}/pki/etcd/healthcheck-client.crt
        - /deploy/{{ name }}/pki/etcd/healthcheck-client.key
        - /deploy/{{ name }}/pki/etcd/peer.crt
        - /deploy/{{ name }}/pki/etcd/peer.key
        - /deploy/{{ name }}/pki/etcd/server.crt
        - /deploy/{{ name }}/pki/etcd/server.key
    - watch_in:
        - module: kubeadm-etcd-push-certs-to-master

{% endfor %}

kubeadm-etcd-push-certs-to-master:
  module.wait:
    - name: cp.push_dir
    - path: /deploy
