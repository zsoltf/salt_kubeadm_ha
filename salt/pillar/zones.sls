{% load_yaml as id_map %}

  frigate-1*:

    - name: kube-etcd-1
      brand: kvm
      vcpus: 2
      ram: 512
      resolvers:
        - "10.5.48.8"
        - "10.5.48.9"
      dns_domain: discdrive.bayphoto.com
      image_uuid: 9aa48095-da9d-41ca-a094-31d1fb476b98
      nics:
        - mac: '02:5c:a1:ab:1e:01'
          ip: dhcp
          mtu: 1500
          nic_tag: admin
          model: virtio

    - name: kube-lb-1
      brand: kvm
      vcpus: 2
      ram: 512
      resolvers:
        - "10.5.48.8"
        - "10.5.48.9"
      dns_domain: discdrive.bayphoto.com
      image_uuid: 9aa48095-da9d-41ca-a094-31d1fb476b98
      nics:
        - mac: '02:5c:a1:ab:1e:02'
          ip: dhcp
          mtu: 1500
          nic_tag: admin
          model: virtio

    - name: kube-master-1
      brand: kvm
      vcpus: 4
      ram: 1024
      resolvers:
        - "10.5.48.8"
        - "10.5.48.9"
      dns_domain: discdrive.bayphoto.com
      image_uuid: 9aa48095-da9d-41ca-a094-31d1fb476b98
      nics:
        - mac: '02:5c:a1:ab:1e:03'
          ip: dhcp
          mtu: 1500
          nic_tag: admin
          model: virtio

  frigate-2*:

    - name: kube-etcd-2
      brand: kvm
      vcpus: 2
      ram: 512
      resolvers:
        - "10.5.48.8"
        - "10.5.48.9"
      dns_domain: discdrive.bayphoto.com
      image_uuid: 9aa48095-da9d-41ca-a094-31d1fb476b98
      nics:
        - mac: '02:5c:a1:ab:1e:04'
          ip: dhcp
          mtu: 1500
          nic_tag: admin
          model: virtio

    - name: kube-lb-2
      brand: kvm
      vcpus: 2
      ram: 512
      resolvers:
        - "10.5.48.8"
        - "10.5.48.9"
      dns_domain: discdrive.bayphoto.com
      image_uuid: 9aa48095-da9d-41ca-a094-31d1fb476b98
      nics:
        - mac: '02:5c:a1:ab:1e:05'
          ip: dhcp
          mtu: 1500
          nic_tag: admin
          model: virtio

    - name: kube-master-2
      brand: kvm
      vcpus: 4
      ram: 1024
      resolvers:
        - "10.5.48.8"
        - "10.5.48.9"
      dns_domain: discdrive.bayphoto.com
      image_uuid: 9aa48095-da9d-41ca-a094-31d1fb476b98
      nics:
        - mac: '02:5c:a1:ab:1e:06'
          ip: dhcp
          mtu: 1500
          nic_tag: admin
          model: virtio

  frigate-3*:

    - name: kube-etcd-3
      brand: kvm
      vcpus: 2
      ram: 512
      resolvers:
        - "10.5.48.8"
        - "10.5.48.9"
      dns_domain: discdrive.bayphoto.com
      image_uuid: 9aa48095-da9d-41ca-a094-31d1fb476b98
      nics:
        - mac: '02:5c:a1:ab:1e:07'
          ip: dhcp
          mtu: 1500
          nic_tag: admin
          model: virtio

    - name: kube-lb-3
      brand: kvm
      vcpus: 2
      ram: 512
      resolvers:
        - "10.5.48.8"
        - "10.5.48.9"
      dns_domain: discdrive.bayphoto.com
      image_uuid: 9aa48095-da9d-41ca-a094-31d1fb476b98
      nics:
        - mac: '02:5c:a1:ab:1e:08'
          ip: dhcp
          mtu: 1500
          nic_tag: admin
          model: virtio

    - name: kube-master-3
      brand: kvm
      vcpus: 4
      ram: 1024
      resolvers:
        - "10.5.48.8"
        - "10.5.48.9"
      dns_domain: discdrive.bayphoto.com
      image_uuid: 9aa48095-da9d-41ca-a094-31d1fb476b98
      nics:
        - mac: '02:5c:a1:ab:1e:09'
          ip: dhcp
          mtu: 1500
          nic_tag: admin
          model: virtio

  frigate-4*:

    - name: kube-worker-1
      brand: kvm
      vcpus: 8
      ram: 4096
      resolvers:
        - "10.5.48.8"
        - "10.5.48.9"
      dns_domain: discdrive.bayphoto.com
      image_uuid: 9aa48095-da9d-41ca-a094-31d1fb476b98
      nics:
        - mac: '02:5c:a1:ab:1e:0a'
          ip: dhcp
          mtu: 1500
          nic_tag: admin
          model: virtio

  frigate-5*:

    - name: kube-worker-2
      brand: kvm
      vcpus: 8
      ram: 4096
      resolvers:
        - "10.5.48.8"
        - "10.5.48.9"
      dns_domain: discdrive.bayphoto.com
      image_uuid: 9aa48095-da9d-41ca-a094-31d1fb476b98
      nics:
        - mac: '02:5c:a1:ab:1e:0b'
          ip: dhcp
          mtu: 1500
          nic_tag: admin
          model: virtio

  frigate-6*:

    - name: kube-worker-3
      brand: kvm
      vcpus: 8
      ram: 4096
      resolvers:
        - "10.5.48.8"
        - "10.5.48.9"
      dns_domain: discdrive.bayphoto.com
      image_uuid: 9aa48095-da9d-41ca-a094-31d1fb476b98
      nics:
        - mac: '02:5c:a1:ab:1e:0c'
          ip: dhcp
          mtu: 1500
          nic_tag: admin
          model: virtio


{% endload %}

{% set zones = salt['grains.filter_by'](id_map, grain='id') %}

zones: {{ zones|yaml }}
