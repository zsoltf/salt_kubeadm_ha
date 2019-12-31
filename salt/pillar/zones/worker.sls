{% from 'zones/init.sls' import apply_placement, defaults %}
{% load_yaml as zones_map %}

us-west-1:
  kube-worker-1:
    brand: {{ defaults['brand'] }}
    cpus: 8
    dns_domain: {{ grains['domain'] }}
    image_uuid: {{ defaults['images']['ubuntu'] }}
    owner: {{ defaults['owner'] }}
    placement: delta
    ram: 32768
    resolvers: {{ grains['dns']['nameservers'] }}
    nics:
      - mac: '02:5c:a1:ab:1e:0a'
        ip: dhcp
        mtu: 1500
        nic_tag: admin
        model: virtio
        allow_mac_spoofing: true
        allow_ip_spoofing: true

  kube-worker-2:
    brand: {{ defaults['brand'] }}
    cpus: 8
    dns_domain: {{ grains['domain'] }}
    image_uuid: {{ defaults['images']['ubuntu'] }}
    owner: {{ defaults['owner'] }}
    placement: epsilon
    ram: 32768
    resolvers: {{ grains['dns']['nameservers'] }}
    nics:
      - mac: '02:5c:a1:ab:1e:0b'
        ip: dhcp
        mtu: 1500
        nic_tag: admin
        model: virtio
        allow_mac_spoofing: true
        allow_ip_spoofing: true

  kube-worker-3:
    brand: {{ defaults['brand'] }}
    cpus: 8
    dns_domain: {{ grains['domain'] }}
    image_uuid: {{ defaults['images']['ubuntu'] }}
    owner: {{ defaults['owner'] }}
    placement: zeta
    ram: 32768
    resolvers: {{ grains['dns']['nameservers'] }}
    nics:
      - mac: '02:5c:a1:ab:1e:0c'
        ip: dhcp
        mtu: 1500
        nic_tag: admin
        model: virtio
        allow_mac_spoofing: true
        allow_ip_spoofing: true

home:
  kube-worker-1:
    brand: {{ defaults['brand'] }}
    cpus: 8
    dns_domain: {{ grains['domain'] }}
    image_uuid: {{ defaults['images']['ubuntu'] }}
    owner: {{ defaults['owner'] }}
    placement: delta
    ram: 4096
    resolvers: {{ grains['dns']['nameservers'] }}
    nics:
      - mac: '02:5c:a1:ab:1e:0a'
        ip: dhcp
        mtu: 1500
        nic_tag: admin
        model: virtio
        allow_mac_spoofing: true
        allow_ip_spoofing: true

{% endload %}
{% set zones = salt['grains.filter_by'](zones_map, grain='datacenter') %}
{{ apply_placement(zones) }}
