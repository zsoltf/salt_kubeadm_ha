{% load_yaml as os_map %}

Debian:
  pkgrepo:
    - humanname: Google Cloud
    - name: 'deb https://apt.kubernetes.io/ kubernetes-xenial main'
    - keyserver: 'https://packages.cloud.google.com/apt/doc/apt-key.gpg'
    - keyid: '6A030B21BA07F4FB'
    - file: /etc/apt/sources.list.d/google-cloud.list

RedHat:
  pkgrepo:
    - humanname: Google Cloud
    - baseurl: 'https://packages.cloud.google.com/yum/repos/kubernetes-el7-$basearch'
    - gpgcheck: 1
    - gpgkey: 'https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg'

{% endload %}
{% set map = salt['grains.filter_by'](os_map) %}

google-cloud-repo:
  pkgrepo.managed: {{ map['pkgrepo']|yaml }}
