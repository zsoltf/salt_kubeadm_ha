kubernetes-install-addons:
  salt.state:
    - tgt: 'G@kube:role:master and *-1*'
    - tgt_type: compound
    - sls: kubernetes.addons

kubernetes-admin-service-account:
  salt.state:
    - tgt: 'G@kube:role:master and *-1*'
    - tgt_type: compound
    - sls: kubernetes.accounts
