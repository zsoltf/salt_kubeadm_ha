{% set etcd_cluster_mine = salt['mine.get']('kube:role:etcd', 'ip', 'grain') | dictsort() %}
{% set first_etcd = salt['mine.get']('kube:role:etcd', 'test.ping', 'grain') | dictsort() | first | first %}
{% set apiserver = pillar['kubernetes']['apiserver'] %}

include:
  - kubeadm

  # TODO: iterate over all masters
  # boostrap first master
  # join rest of masters
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
    - name: /etc/kubernetes/kubeadm-init.yaml
    - contents: |
        apiVersion: kubeadm.k8s.io/v1beta2
        kind: InitConfiguration
        #bootstrapTokens:
        #  - token: "qsif7o.1vagz2tz9zuy9d73"
        #    description: "kubeadm bootstrap token"
        #    ttl: "24h"
        #certificateKey: "cec4301ea5447f0ba6a06ef8715a553ae9b546e13f458b86a586f29e4562720c"
        nodeRegistration:
          criSocket: "/var/run/dockershim.sock"
          kubeletExtraArgs:
            cgroup-driver: "systemd"
        ---
        apiVersion: kubeadm.k8s.io/v1beta2
        kind: ClusterConfiguration
        kubernetesVersion: stable
        controlPlaneEndpoint: "{{ apiserver }}:443"
        clusterName: "boneyard cluster"
        etcd:
            external:
                endpoints:
                {%- for _,ip in etcd_cluster_mine %}
                - https://{{ ip[0] }}:2379
                {%- endfor %}
                caFile: /etc/kubernetes/pki/etcd/ca.crt
                certFile: /etc/kubernetes/pki/apiserver-etcd-client.crt
                keyFile: /etc/kubernetes/pki/apiserver-etcd-client.key
        networking:
          dnsDomain: "boneyard.local"


kubeadm-master-init:
  cmd.run:
    - name: kubeadm init --config /etc/kubernetes/kubeadm-init.yaml
    - creates:
        - /etc/kubernetes/admin.conf
    - requires:
        file: kubeadm-master-config
