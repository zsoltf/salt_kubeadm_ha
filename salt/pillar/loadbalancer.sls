{% from 'kubernetes.sls' import kube with context %}
{% load_yaml as map %}

base:
  scripts:
    - name: check_haproxy
      interval: 1
      weight: -25
      value: "killall -0 haproxy"
  virtual_instances:
    - name: haproxy_vi
      advert_int: 1
      password: kube
      interface: ens4
      track_script: check_haproxy
      virtual_ip: "{{ kube['apiserver'] }}/24 dev ens4"
      virtual_router_id: 60


us-west-1:
  virtual_instances:
    - name: haproxy_vi
      advert_int: 1
      password: kube
      interface: net0
      track_script: check_haproxy
      virtual_ip: "{{ kube['apiserver'] }}/23 dev net0"
      virtual_router_id: 60

{% endload %}

loadbalancer:
  {{ salt['grains.filter_by'](map, grain='datacenter', base='base')|yaml }}
