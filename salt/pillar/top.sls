base:

  '*':
    - test
    - ip-mine

  'kube:role':
    - match: grain
    - kubernetes
