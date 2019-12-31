{% load_yaml as map %}

  lb:
    config:
      scripts:
        - name: check_haproxy
          interval: 1
          weight: -25
          value: "killall -0 haproxy"
      virtual_instances:
        - name: haproxy_vi
          advert_int: 1
          password: kube
          interface: net0
          track_script: check_haproxy
          virtual_ip: "{{ salt['pillar.get']('kubernetes:apiserver', 'localhost') }}/23 dev net0"
          virtual_router_id: 60

{% endload %}
{% set keepalived = salt['grains.filter_by'](map, grain='kube:role', base='base') %}

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
        scripts: {{ keepalived.config.scripts }}
        virtual_instances: {{ keepalived.config.virtual_instances }}
    - source: salt://kubeadm/lb/keepalived.jinja
    - template: jinja
    - watch_in:
      - service: keepalived

  service.running:
    - enable: true
