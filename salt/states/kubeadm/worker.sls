# TODO: use JoinConfiguration when it's ready

kubeadm-join-worker-{{ grains['id'] }}:
  cmd.run:
    - name: |
        kubeadm join $apiserver:443 \
          --token $token \
          --discovery-token-unsafe-skip-ca-verification
    - env: {{ salt['pillar.get']('kubernetes', {}) }}
    - creates:
        - /etc/kubernetes/bootstrap-kubelet.conf
