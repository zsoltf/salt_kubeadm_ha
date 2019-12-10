# bootstrap:
# edit pillar/kube.sls
# set datacenter grain on hypervisors
# salt 'frigate*' grains.set datacenter us-west-1

hypervisor-grains:
  salt.state:
    - tgt: 'datacenter:*'
    - tgt_type: grain
    - sls: grains

orchestrate-zones:
  salt.runner:
    - name: state.orchestrate
    - mods:
        - orchestrate.zones

orchestrate-kubeadm:
  salt.runner:
    - name: state.orchestrate
    - mods:
        - orchestrate.kubeadm
    - require:
        - salt: orchestrate-zones
