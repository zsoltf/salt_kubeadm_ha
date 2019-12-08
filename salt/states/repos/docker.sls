{% load_yaml as os_map %}

default:
  pkgrepo: []

Debian:
  pkgrepo:
    - humanname: Docker CE Stable
    - name: 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable'
    - keyserver: 'https://download.docker.com/linux/ubuntu/gpg'
    - keyid: '7EA0A9C3F273FCD8'
    - file: /etc/apt/sources.list.d/docker-ce.list

RedHat:
  pkgrepo:
    - humanname: Docker CE Stable
    - baseurl: 'https://download.docker.com/linux/centos/7/$basearch/stable'
    - gpgcheck: 1
    - gpgkey: 'https://download.docker.com/linux/centos/gpg'

{% endload %}
{% set map = salt['grains.filter_by'](os_map) %}

docker-ce-stable:
  pkgrepo.managed: {{ map['pkgrepo']|yaml }}
