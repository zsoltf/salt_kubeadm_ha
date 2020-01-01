{% load_yaml as map %}

base:
  apiserver: 10.99.99.99
  token: qsif7o.1vagz2tz9zuy9d73
  certificate_key: cec4301ea5447f0ba6a06ef8715a553ae9b546e13f458b86a586f29e4562720c

home:
  apiserver: 192.168.100.99

test:
  apiserver: 10.193.227.254

{% endload %}
{% set kube = salt['grains.filter_by'](map, grain='datacenter', base='base') %}

kubernetes:
  {{ kube|yaml }}
