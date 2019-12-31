{% load_yaml as map %}

base:
  roles: []
  placements: []

home:

  prometheus:
    roles:
      - lb
      - master
      - etcd
      - worker
    placements:
      - alpha
      - beta
      - gamma
      - delta
      - epsilon
      - zeta

us-west-1:

  frigate-1*:
    roles:
      - etcd
      - lb
      - master
      - worker
    placements:
      - alpha
      - delta

  frigate-2*:
    roles:
      - etcd
      - lb
      - master
      - worker
    placements:
      - beta
      - epsilon

  frigate-3*:
    roles:
      - etcd
      - lb
      - worker
      - master
    placements:
      - gamma
      - zeta

{% endload %}
{% set overrides = salt['grains.filter_by'](map, grain='datacenter', base='base') %}
{% set grains = salt['grains.filter_by'](overrides, grain='id', base='base') %}

grains:
  hyper: {{ grains|yaml }}
