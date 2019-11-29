base:
  '*':
    - test
    - repos
    - kubeadm
  'os:SmartOS':
    - match: grain
    - vms
