{% set keepalived = pillar['loadbalancer'] %}

sysctl_nonlocal_bind:
  sysctl.present:
    - name: 'net.ipv4.ip_nonlocal_bind'
    - value: 1

keepalived:

  pkg.installed:
    - watch_in:
      - service: keepalived

  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - context:
        scripts: {{ keepalived['scripts'] }}
        virtual_instances: {{ keepalived['virtual_instances'] }}
    - source: salt://kubeadm/lb/keepalived.jinja
    - template: jinja
    - watch_in:
      - service: keepalived

  service.running:
    - enable: true
