containerd:
  pkg.installed: []
  service.running:
    - require:
        - pkg: containerd

crictl-container-runtime-endpoint:
  file.managed:
    - name: /etc/crictl.yaml
    - contents: |
        runtime-endpoint: unix:///run/containerd/containerd.sock
        image-endpoint: unix:///run/containerd/containerd.sock
