{% load_yaml as os_map %}

Debian:
  default_path: /etc/default/kubelet

RedHat:
  default_path: /etc/sysconfig/kubelet

{% endload %}
{% set map = salt['grains.filter_by'](os_map) %}

include:
  - .containerd
  - repos.google-cloud

kubeadm-packages:
  pkg.installed:
    - pkgs:
        - kubeadm
        - kubectl
        - kubelet
    - require:
        - google-cloud-repo

kubelet-args:
  file.managed:
    - name: {{ map['default_path'] }}
    - contents: KUBELET_EXTRA_ARGS=--cgroup-driver=systemd
    - require:
        - pkg: kubeadm-packages

kubelet-service-enabled:
  service.enabled:
    - name: kubelet
    - require:
        - file: kubelet-args
