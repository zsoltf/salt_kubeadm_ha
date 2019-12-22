include:
  - repos.docker

kubeadm-docker-packages:
  pkg.installed:
    - pkgs:
        - docker-ce
        - docker-ce-cli
        - containerd.io

kubeadm-docker-config:
  file.managed:
    - name: /etc/docker/daemon.json
    - makedirs: True
    - contents: |
        {
          "exec-opts": ["native.cgroupdriver=systemd"],
          "log-driver": "json-file",
          "log-opts": {
            "max-size": "100m"
          },
          "storage-driver": "overlay2"
        }

kubeadm-docker-service:
  service.running:
    - name: docker
    - require:
      - pkg: kubeadm-docker-packages
    - watch:
      - file: kubeadm-docker-config
