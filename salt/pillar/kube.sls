{% load_yaml as map %}

base:
  default:
    apiserver: localhost

us-west-1:

  default:
    apiserver: 10.250.18.200

  frigate-1*:
    grains:
      roles:
        - etcd
        - lb
        - master
      placements:
        - alpha

  frigate-2*:
    grains:
      roles:
        - etcd
        - lb
        - master
      placements:
        - beta

  frigate-3*:
    grains:
      roles:
        - etcd
        - lb
        - master
      placements:
        - gamma

  frigate-4*:
    grains:
      roles:
        - worker
      placements:
        - delta

  frigate-5*:
    grains:
      roles:
        - worker
      placements:
        - epsilon

  frigate-6*:
    grains:
      roles:
        - worker
      placements:
        - zeta

home:

  default:
    apiserver: 192.168.100.99

  prometheus:
    grains:
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

{% endload %}
{% set overrides = salt['grains.filter_by'](map, grain='datacenter', base='base') %}
{% set kube = salt['grains.filter_by'](overrides, grain='id', base='base') %}

kubernetes:
  {{ kube|yaml }}
