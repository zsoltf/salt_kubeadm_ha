### install etcd ###

install-kubeadm-on-etcd:
  salt.state:
    - tgt: 'kube-etcd-*'
    - sls: kubeadm

install-etcd-service:
  salt.state:
    - tgt: 'kube-etcd-*'
    - sls: kubeadm.etcd.service
    - require:
        - salt: install-kubeadm-on-etcd

generate-etcd-certs:
  salt.state:
    - tgt: 'kube-etcd-1*'
    - sls: kubeadm.etcd.bootstrap
    - require:
        - salt: install-etcd-service

deploy-etcd-certs:
  salt.state:
    - tgt: 'kube-etcd-*'
    - sls: kubeadm.etcd.certs
    - require:
        - salt: generate-etcd-certs

generate-etcd-manifests:
  salt.state:
    - tgt: 'kube-etcd-*'
    - sls: kubeadm.etcd.config
    - require:
        - salt: deploy-etcd-certs
