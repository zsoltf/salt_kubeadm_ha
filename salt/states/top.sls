base:
  '*':
    - test

  'virtual:physical':
    - match: grain
    - grains

  'os:SmartOS':
    - match: grain
    - zones

  'kube:role:etcd':
    - match: grain
    - kubeadm.etcd

  'kube:role:lb':
    - match: grain
    - kubeadm.lb

  'kube:role:master':
    - match: grain
    - kubeadm

  'kube:role:worker':
    - match: grain
    - kubeadm
