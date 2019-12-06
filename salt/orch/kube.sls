### create vms ###

create-zones:
  salt.state:
    - tgt: 'frigate-*'
    - sls: zones

wait-for-minions:
  salt.wait_for_event:
    - name: salt/minion/*/start
    - id_list:
        - kube-etcd-1
        - kube-etcd-2
        - kube-etcd-3
        - kube-lb-1
        - kube-lb-2
        - kube-lb-3
        - kube-master-1
        - kube-master-2
        - kube-master-3
        - kube-worker-1
        - kube-worker-2
        - kube-worker-3
    - require:
        - salt: create-zones

### install etcd ###

install-kubeadm-on-etcd:
  salt.state:
    - tgt: 'kube-etcd-*'
    - sls: kubeadm
    - require:
        - salt: wait-for-minions

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
