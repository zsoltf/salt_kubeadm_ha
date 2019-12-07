testo:
  test.nop:
    - name: test

# create_test_vm:
#   smartos.vm_present:
#     - config:
#         reprovision: true
#     - vmconfig:
#         image_uuid: 3dbbdcca-2eab-11e8-b925-23bf77789921
#         brand: lx
#         hostname: vmtesto
#         alias: vmtesto
#         quota: 5
#         max_physical_memory: 512
#         tags:
#           label: 'test vm'
#           owner: 'zsolt'
#         nics:
#           "00:00:00:00:00:01":
#             nic_tag: admin
#             mtu: 1500
#             ips:
#               - dhcp
#         customer_metadata:
#           root_authorized_keys: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCr8LopRSIg+Ng7oWqEqfxcXL+Ly8FK3E1A/RMvMHOOSV7zXCrqZnFhtXA3PByYG0xXRJjI2G2Kt0OwCR6UWfRSom/GIXuZQUyd8fq6QaceY+L7SnyekLRsfpTaJ6hxQoxCi18tiIMJQhp21reclyJ9up1Sncju75y1T2aI9Gu035TYBFGs9kiGOz+MI25TDiUKmXML9UcWaOzTtt2WQopV9i0sYHtSFeOKT3UCqtjCzy/tx9iOn8c0Hzzpm/7L8KPBlOZXCit2NlmWjWzX+fhdGt/i2NOmpZ1Ni0bX4FRwvTTJevdl8KPm0Epef/63wOAoKER5F0lY3BgKYwTdfshn zsolt@hyperion"
#           user-script: "/usr/sbin/mdata-get root_authorized_keys > ~root/.ssh/authorized_keys; yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest.el7.noarch.rpm; yum install -y salt-minion git; systemctl enable salt-minion; /usr/sbin/mdata-get sdc:hostname > /etc/hostname; /usr/sbin/mdata-get sdc:hostname > /etc/salt/minion_id; systemctl disable firewalld"

# ubuntu-18-cloudimg:
#   smartos.image_present:
#     - name: 9aa48095-da9d-41ca-a094-31d1fb476b98

ubuntu-18-cloudimg:
  cmd.run:
    - name: imgadm import 9aa48095-da9d-41ca-a094-31d1fb476b98
    - creates: /dev/zvol/dsk/zones/9aa48095-da9d-41ca-a094-31d1fb476b98

{% set zones = salt['pillar.get']('zones', []) %}

{% for zone in zones %}

zone_{{ zone['name'] }}:
  smartos.vm_present:
    - vmconfig:
        brand: {{ zone['brand'] }}
        alias: {{ zone['name'] }}
        vcpus: {{ zone['vcpus'] }}
        ram: {{ zone['ram'] }}
        resolvers: {{ zone['resolvers'] }}
        hostname: {{ zone['name'] }}
        tags:
          name: {{ zone['name'] }}
          type: {{ zone['name'].split('-')[1] }}
          role: 'kubernetes'
          owner: 'zsolt'
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
          root_authorized_keys: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDThfGA6c88VJPeqJHSRlQT8GplLGUXidtHc+3L4zHHu31H5By2yRnWEnCB1+MXgmP41kFhu1ZKa6TfvrbDXVsXj7awQt0d45RP9mKcKTMCKK41PXap78bsz9QcNdYVI1UP3BGEQRxrrIo3QINVzgz1cu9Wqwcer03KA4pf/6givvYCAEUr9U5/HC6BoBzqS1CxrUVVOuL9lCrVaFZOXN0fldsjXNn2CYjIDxvST1oygOB7lfIaS61HS3mBfrqCvTrg+uFZYybvlrvMGBkIox+RVSRve+hZ0nAsJj+FG7owT6QN3Ncyrcrf7aRSOXYGRA5Uvx5UH6JQoBDwKVpWai+x kryten@trusty"
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
              http_proxy: http://apt.bayphoto.com/
              https_proxy: DIRECT
              sources:
                salt:
                  keyserver: "https://repo.saltstack.com/py3/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub"
                  keyid: "0E08A149DE57BFBE"
                  source: "deb http://repo.saltstack.com/py3/ubuntu/18.04/amd64/latest bionic main"

            salt_minion:
              conf:
                master: '10.250.18.111'
              grains:
                type: {{ zone['name'].split('-')[1] }}
                role: 'kubernetes'
                env: 'test'
                owner: 'zsolt'

            mounts:
              - [ swap ]

            swap:
              size: 0

            disable_root: false
            users:
              - name: zsolt
                groups: adm,sudo,lxd
                sudo: "ALL=(ALL) NOPASSWD:ALL"
                lock_passwd: true
                shell: /bin/bash
                ssh_authorized_keys:
                  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDThfGA6c88VJPeqJHSRlQT8GplLGUXidtHc+3L4zHHu31H5By2yRnWEnCB1+MXgmP41kFhu1ZKa6TfvrbDXVsXj7awQt0d45RP9mKcKTMCKK41PXap78bsz9QcNdYVI1UP3BGEQRxrrIo3QINVzgz1cu9Wqwcer03KA4pf/6givvYCAEUr9U5/HC6BoBzqS1CxrUVVOuL9lCrVaFZOXN0fldsjXNn2CYjIDxvST1oygOB7lfIaS61HS3mBfrqCvTrg+uFZYybvlrvMGBkIox+RVSRve+hZ0nAsJj+FG7owT6QN3Ncyrcrf7aRSOXYGRA5Uvx5UH6JQoBDwKVpWai+x kryten@trusty

            final_message: "Is this thing on? $UPTIME"

            cloud_final_modules:
              - salt-minion

{% endfor %}
