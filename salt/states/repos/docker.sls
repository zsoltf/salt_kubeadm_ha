{% load_yaml as os_map %}

Debian:
  key: 'deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable'
  url: 'deb https://apt.kubernetes.io/ kubernetes-xenial main'

RedHat:
  key: 'https://download.docker.com/linux/centos/gpg'
  url: 'https://download.docker.com/linux/centos/7/$basearch/stable'

{% endload %}
{% set map = salt['grains.filter_by'](os_map) %}

docker-ce-stable:
  pkgrepo.managed:
    - humanname: Docker CE Stable
    - baseurl: {{ map['url'] }}
    - gpgcheck: 1
    - gpgkey: {{ map['key'] }}
