### install etcd ###

install-kubeadm-on-etcd:
  salt.state:
    - tgt: 'role:etcd'
    - tgt_type: 'grain'
    - sls: kubeadm

install-etcd-service:
  salt.state:
    - tgt: 'role:etcd'
    - tgt_type: 'grain'
    - sls: kubeadm.etcd.service
    - require:
        - salt: install-kubeadm-on-etcd

generate-etcd-certs:
  salt.state:
    - tgt: 'kube-etcd-1*'
    - sls: kubeadm.etcd.bootstrap
    - require:
        - salt: install-etcd-service

deploy-etcd-configs:
  salt.state:
    - tgt: 'role:etcd'
    - tgt_type: 'grain'
    - sls: kubeadm.etcd.config
    - require:
        - salt: generate-etcd-certs
