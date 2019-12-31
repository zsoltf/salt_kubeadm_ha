# ubuntu-18-cloudimg:
#   smartos.image_present:
#     - name: 9aa48095-da9d-41ca-a094-31d1fb476b98

{% set zones = salt['pillar.get']('zones', {}) %}

{% for name, zone in zones.items() %}

zone_{{ name }}_image:
  cmd.run:
    - name: imgadm import {{ zone['image_uuid'] }}
    - creates: /dev/zvol/dsk/zones/{{ zone['image_uuid'] }}

zone_{{ name }}:
  smartos.vm_present:
    - vmconfig:
        brand: {{ zone['brand'] }}
        alias: {{ name }}
        vcpus: {{ zone['cpus'] }}
        ram: {{ zone['ram'] }}
        resolvers: {{ zone['resolvers'] }}
        hostname: {{ name }}
        tags:
          app: 'kubernetes'
          datacenter: {{ grains['datacenter'] }}
          name: {{ name }}
          role: {{ name.split('-')[1] }}
          owner: {{ zone['owner'] }}
        disks:
          disk0:
            image_uuid: {{ zone['image_uuid'] }}
            model: virtio
            boot: true
        nics:
          {%- for nic in zone['nics'] %}
          '{{ nic['mac'] }}': {{ nic|yaml }}
          {%- endfor %}
        customer_metadata:
          root_authorized_keys: {{ pillar['zone']['defaults']['ssh_keys']|first }}
          cloud-init:user-data: |
            #cloud-config

            # prevent services from starting after install
            # turn off unattended upgrades
            # stop messing with resolv.conf
            # turn off swap for kubelet
            bootcmd:
              - 'echo "#!/bin/bash\nexit 101" > /usr/sbin/policy-rc.d'
              - 'chmod +x /usr/sbin/policy-rc.d'
              - 'rm /etc/apt/apt.conf.d/50unattended-upgrades'
              - 'echo "nameserver {{ zone['resolvers']|join(' ') }}\nsearch {{ zone['dns_domain'] }}" > /etc/resolv.conf'
              - 'systemctl mask swap.target'
              - 'swapoff -a'

            dns_domain: {{ zone['dns_domain'] }}

            apt:
              sources:
                salt:
                  keyserver: "https://repo.saltstack.com/py3/ubuntu/18.04/amd64/2019.2/SALTSTACK-GPG-KEY.pub"
                  keyid: "0E08A149DE57BFBE"
                  source: "deb http://repo.saltstack.com/py3/ubuntu/18.04/amd64/2019.2 bionic main"

            salt_minion:
              conf:
                master: {{ grains['master'] }}
              grains:
                app: 'kubernetes'
                datacenter: {{ grains['datacenter'] }}
                kube:
                  role: {{ name.split('-')[1] }}
                owner: {{ zone['owner'] }}

            mounts:
              - [ swap ]

            swap:
              size: 0

            disable_root: false
            users:
              - name: {{ zone['owner'] }}
                groups: adm,sudo,lxd
                sudo: "ALL=(ALL) NOPASSWD:ALL"
                lock_passwd: true
                shell: /bin/bash
                ssh_authorized_keys: {{ pillar['zone']['defaults']['ssh_keys'] }}

            final_message: "Is this thing on? $UPTIME"

            cloud_final_modules:
              - salt-minion

{% endfor %}
