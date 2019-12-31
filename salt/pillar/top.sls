base:

  '*':
    - test
    - ip-mine

  'datacenter:*':
    - match: grain
    - kubernetes


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
