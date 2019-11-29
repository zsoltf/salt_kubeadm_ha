include:
  - repos.docker

kubeadm-docker-packages:
  pkg.installed:
    - pkgs:
        - docker-ce
        - docker-ce-cli
        - containerd.io
