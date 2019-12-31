{% set kube_mine = salt['mine.get']('kube:role:master', 'ip', 'grain') | dictsort() %}

haproxy-package:
  pkg.installed:
    - name: haproxy

haproxy-config:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - context:
        kube_mine: {{ kube_mine|yaml }}
        apiserver: {{ salt['pillar.get']('kubernetes:apiserver', 'localhost') }}
    - source: salt://kubeadm/lb/haproxy.cfg.jinja
    - template: jinja

haproxy-service:
  service.running:
    - name: haproxy
    - require:
        - pkg: haproxy-package
    - watch:
        - file: haproxy-config
