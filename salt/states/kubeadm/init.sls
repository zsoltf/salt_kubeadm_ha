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

kubelet-config:
  file.managed:
    - name: /var/lib/kubelet/config.yaml
    - makedirs: True
    - contents: |
        apiVersion: kubelet.config.k8s.io/v1beta1
        kind: KubeletConfiguration
        cgroupDriver: systemd

kubelet-service:
  service.running:
    - name: kubelet
