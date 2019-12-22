base:
  '*':
    - test

  'kube:role:etcd':
    - match: grain
    - kubeadm.etcd

  'kube:role:lb':
    - match: grain
    - kubeadm.lb.haproxy
    - kubeadm.lb.keepalived

  'kube:role:master':
    - match: grain
    - kubeadm

  'kube:role:worker':
    - match: grain
    - kubeadm
