base:

  '*':
    - test
    - ip-mine


  # datacenter

  'datacenter:*':
    - match: grain
    - kube

  # hypervisor pillars

  'hyper:roles:etcd':
    - match: grain
    - zones.etcd

  'hyper:roles:lb':
    - match: grain
    - zones.lb

  'hyper:roles:master':
    - match: grain
    - zones.master

  'hyper:roles:worker':
    - match: grain
    - zones.worker
