orchestrate-zones:
  salt.runner:
    - name: state.orchestrate
    - mods:
        - orchestrate.zones

orchestrate-kubernetes:
  salt.runner:
    - name: state.orchestrate
    - mods:
        - orchestrate.kube
    - require:
        - salt: orchestrate-zones
