{% load_yaml as map %}

base:
  default:
    apiserver: localhost
    token: qsif7o.1vagz2tz9zuy9d73
    certificate_key: cec4301ea5447f0ba6a06ef8715a553ae9b546e13f458b86a586f29e4562720c

us-west-1:

  default:
    apiserver: 10.250.18.200

  frigate-1*:
    grains:
      roles:
        - etcd
        - lb
        - master
        - worker
      placements:
        - alpha
        - delta

  frigate-2*:
    grains:
      roles:
        - etcd
        - lb
        - master
        - worker
      placements:
        - beta
        - epsilon

  frigate-3*:
    grains:
      roles:
        - etcd
        - lb
        - worker
        - master
      placements:
        - gamma
        - zeta

  #carrier-1*:
  #  grains:
  #    roles:
  #      - worker
  #    placements:
  #      - delta
  #      - epsilon
  #      - zeta

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
