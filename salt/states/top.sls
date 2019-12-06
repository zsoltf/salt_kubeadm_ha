base:
  '*':
    - test
    - repos
    - kubeadm
  'os:SmartOS':
    - match: grain
    - zones
