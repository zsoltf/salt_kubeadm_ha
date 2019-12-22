{% from 'zones/init.sls' import apply_placement, defaults %}
{% load_yaml as zones %}

  kube-master-1:
    brand: {{ defaults['brand'] }}
    cpus: 4
    dns_domain: {{ grains['domain'] }}
    image_uuid: {{ defaults['images']['ubuntu'] }}
    owner: {{ defaults['owner'] }}
    placement: alpha
    ram: 1024
    resolvers: {{ grains['dns']['nameservers'] }}
    nics:
      - mac: '02:5c:a1:ab:1e:03'
        ip: dhcp
        mtu: 1500
        nic_tag: admin
        model: virtio
        allow_mac_spoofing: true
        allow_ip_spoofing: true

  kube-master-2:
    brand: {{ defaults['brand'] }}
    cpus: 4
    dns_domain: {{ grains['domain'] }}
    image_uuid: {{ defaults['images']['ubuntu'] }}
    owner: {{ defaults['owner'] }}
    placement: beta
    ram: 1024
    resolvers: {{ grains['dns']['nameservers'] }}
    nics:
      - mac: '02:5c:a1:ab:1e:06'
        ip: dhcp
        mtu: 1500
        nic_tag: admin
        model: virtio
        allow_mac_spoofing: true
        allow_ip_spoofing: true

  kube-master-3:
    brand: {{ defaults['brand'] }}
    cpus: 4
    dns_domain: {{ grains['domain'] }}
    image_uuid: {{ defaults['images']['ubuntu'] }}
    owner: {{ defaults['owner'] }}
    placement: gamma
    ram: 1024
    resolvers: {{ grains['dns']['nameservers'] }}
    nics:
      - mac: '02:5c:a1:ab:1e:09'
        ip: dhcp
        mtu: 1500
        nic_tag: admin
        model: virtio
        allow_mac_spoofing: true
        allow_ip_spoofing: true

{% endload %}
{{ apply_placement(zones) }}
