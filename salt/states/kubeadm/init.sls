include:
  - .docker
  - repos.google-cloud

kubernetes-pillar-configured:
  test.check_pillar:
    - present:
        - kubernetes

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
