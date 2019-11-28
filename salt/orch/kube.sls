hello-world:
  salt.function:
    - name: cmd.run
    - arg:
      - uname -a
    - tgt: '*'

hello-vm:
  salt.state:
    - tgt: 'prometheus*'
    - sls:
      - vms
