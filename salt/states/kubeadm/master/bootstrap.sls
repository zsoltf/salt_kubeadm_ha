{% set etcd_cluster_mine = salt['mine.get']('kube:role:etcd', 'ip', 'grain') | dictsort() %}
{% set first_etcd = salt['mine.get']('kube:role:etcd', 'test.ping', 'grain') | dictsort() | first | first %}
{% set apiserver = pillar['kubernetes']['apiserver'] %}

include:
  - kubeadm

kubeadm-etcd-certificates-for-master:
  file.recurse:
    - name: /etc/kubernetes
    - source: salt://minionfs/{{ first_etcd }}.{{ grains['domain'] }}/deploy/{{ first_etcd }}
    - source: salt://minionfs/{{ first_etcd }}/deploy/{{ first_etcd }}
    #- show_changes: False
    - include_pat: 'E@(.*pki\/apiserver.*)|(.*ca.crt)'
    - keep_source: False

kubeadm-master-config:
  file.managed:
    - name: /etc/kubernetes/kubeadm-master.yaml
    - contents: |
        apiVersion: kubeadm.k8s.io/v1beta2
        kind: ClusterConfiguration
        kubernetesVersion: stable
        controlPlaneEndpoint: "{{ apiserver }}:443"
        etcd:
            external:
                endpoints:
                {%- for _,ip in etcd_cluster_mine %}
                - https://{{ ip[0] }}:2379
                {%- endfor %}
                caFile: /etc/kubernetes/pki/etcd/ca.crt
                certFile: /etc/kubernetes/pki/apiserver-etcd-client.crt
                keyFile: /etc/kubernetes/pki/apiserver-etcd-client.key
