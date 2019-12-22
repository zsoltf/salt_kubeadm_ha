{% load_yaml as map %}

base:
  default:
    apiserver: localhost
    token: qsif7o.1vagz2tz9zuy9d73
    certificate_key: cec4301ea5447f0ba6a06ef8715a553ae9b546e13f458b86a586f29e4562720c

home:

  default:
    apiserver: 192.168.100.99

{% endload %}
{% set overrides = salt['grains.filter_by'](map, grain='datacenter', base='base') %}
{% set kube = salt['grains.filter_by'](overrides, grain='id', base='base') %}

kubernetes:
  {{ kube|yaml }}
