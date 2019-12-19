include:
  - .docker
  - repos.google-cloud

kubeadm-packages:
  pkg.installed:
    - pkgs:
        - kubeadm
        - kubectl
        - kubelet
    - hold: True
    - require:
        - google-cloud-repo

kubelet-service:
  service.running:
    - name: kubelet
