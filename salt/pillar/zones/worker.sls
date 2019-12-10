{% from 'zones/init.sls' import apply_placement, defaults %}
{% load_yaml as zones %}

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

  kube-worker-2:
    brand: {{ defaults['brand'] }}
    cpus: 8
    dns_domain: {{ grains['domain'] }}
    image_uuid: {{ defaults['images']['ubuntu'] }}
    owner: {{ defaults['owner'] }}
    placement: epsilon
    ram: 4096
    resolvers: {{ grains['dns']['nameservers'] }}
    nics:
      - mac: '02:5c:a1:ab:1e:0b'
        ip: dhcp
        mtu: 1500
        nic_tag: admin
        model: virtio

  kube-worker-3:
    brand: {{ defaults['brand'] }}
    cpus: 8
    dns_domain: {{ grains['domain'] }}
    image_uuid: {{ defaults['images']['ubuntu'] }}
    owner: {{ defaults['owner'] }}
    placement: zeta
    ram: 4096
    resolvers: {{ grains['dns']['nameservers'] }}
    nics:
      - mac: '02:5c:a1:ab:1e:0c'
        ip: dhcp
        mtu: 1500
        nic_tag: admin
        model: virtio

{% endload %}
{{ apply_placement(zones) }}
