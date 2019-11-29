include:
  - repos.epel
  - repos.google-cloud

kubeadm-packages:
  pkg.installed:
    - pkgs:
        - kubeadm
        - kubectl
        - kubelet
    - require:
        - google-cloud-repo

containerd-runtime:
  pkg.installed:
    - name: containerd
    - require:
        - pkg: epel
        - pkg: kubeadm-packages

kubelet-args:
  file.managed:
    - name: /etc/sysconfig/kubelet
    - contents: KUBELET_EXTRA_ARGS=--cgroup-driver=systemd
    - require:
        - pkg: kubeadm-packages

kubelet-service-enabled:
  service.enabled:
    - name: kubelet
    - require:
        - file: kubelet-args
