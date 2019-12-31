# bootstrap:
# edit pillar/kubernetes.sls

orchestrate-kubeadm:
  salt.runner:
    - name: state.orchestrate
    - mods:
        - orchestrate.kubeadm

orchestrate-kuberentes:
  salt.runner:
    - name: state.orchestrate
    - mods:
        - orchestrate.kubernets
    - require:
      - salt: orchestrate-kubeadm
