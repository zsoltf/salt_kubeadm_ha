orchestrate-zones:
  salt.runner:
    - name: state.orchestrate
    - mods:
        - orch.zones

orchestrate-kubernetes:
  salt.runner:
    - name: state.orchestrate
    - mods:
        - orch.kube
    - require:
        - salt: orchestrate-zones
