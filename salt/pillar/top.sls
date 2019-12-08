base:

  '*':
    - test
    - ip-mine

  'kube:role:etcd':
    - match: grain
    - zones.kvm.etcd

  'kube:role:lb':
    - match: grain
    - zones.kvm.lb

  'kube:role:master':
    - match: grain
    - zones.kvm.master

  'kube:role:worker':
    - match: grain
    - zones.kvm.worker
