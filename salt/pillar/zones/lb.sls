{% from 'zones/init.sls' import apply_placement, defaults %}
{% load_yaml as zones %}

  kube-lb-1:
    brand: {{ defaults['brand'] }}
    cpus: 2
    dns_domain: {{ grains['domain'] }}
    image_uuid: {{ defaults['images']['ubuntu'] }}
    owner: {{ defaults['owner'] }}
    placement: alpha
    ram: 512
    resolvers: {{ grains['dns']['nameservers'] }}
    nics:
      - mac: '02:5c:a1:ab:1e:02'
        ip: dhcp
        mtu: 1500
        nic_tag: admin
        model: virtio
        allow_mac_spoofing: true
        allow_ip_spoofing: true

  kube-lb-2:
    brand: {{ defaults['brand'] }}
    cpus: 2
    dns_domain: {{ grains['domain'] }}
    image_uuid: {{ defaults['images']['ubuntu'] }}
    owner: {{ defaults['owner'] }}
    placement: beta
    ram: 512
    resolvers: {{ grains['dns']['nameservers'] }}
    nics:
      - mac: '02:5c:a1:ab:1e:05'
        ip: dhcp
        mtu: 1500
        nic_tag: admin
        model: virtio
        allow_mac_spoofing: true
        allow_ip_spoofing: true

  kube-lb-3:
    brand: {{ defaults['brand'] }}
    cpus: 2
    dns_domain: {{ grains['domain'] }}
    image_uuid: {{ defaults['images']['ubuntu'] }}
    owner: {{ defaults['owner'] }}
    placement: gamma
    ram: 512
    resolvers: {{ grains['dns']['nameservers'] }}
    nics:
      - mac: '02:5c:a1:ab:1e:08'
        ip: dhcp
        mtu: 1500
        nic_tag: admin
        model: virtio
        allow_mac_spoofing: true
        allow_ip_spoofing: true

{% endload %}
{{ apply_placement(zones) }}
