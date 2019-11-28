create_test_vm:
  smartos.vm_present:
    - config:
        reprovision: true
    - vmconfig:
        image_uuid: 3dbbdcca-2eab-11e8-b925-23bf77789921
        brand: lx
        hostname: vmtesto
        alias: vmtesto
        quota: 5
        max_physical_memory: 512
        tags:
          label: 'test vm'
          owner: 'zsolt'
        nics:
          "00:00:00:00:00:01":
            nic_tag: admin
            mtu: 1500
            ips:
              - dhcp
        customer_metadata:
          root_authorized_keys: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCr8LopRSIg+Ng7oWqEqfxcXL+Ly8FK3E1A/RMvMHOOSV7zXCrqZnFhtXA3PByYG0xXRJjI2G2Kt0OwCR6UWfRSom/GIXuZQUyd8fq6QaceY+L7SnyekLRsfpTaJ6hxQoxCi18tiIMJQhp21reclyJ9up1Sncju75y1T2aI9Gu035TYBFGs9kiGOz+MI25TDiUKmXML9UcWaOzTtt2WQopV9i0sYHtSFeOKT3UCqtjCzy/tx9iOn8c0Hzzpm/7L8KPBlOZXCit2NlmWjWzX+fhdGt/i2NOmpZ1Ni0bX4FRwvTTJevdl8KPm0Epef/63wOAoKER5F0lY3BgKYwTdfshn zsolt@hyperion"
          user-script: "/usr/sbin/mdata-get root_authorized_keys > ~root/.ssh/authorized_keys; yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest.el7.noarch.rpm; yum install -y salt-minion git; systemctl enable salt-minion; /usr/sbin/mdata-get sdc:hostname > /etc/hostname; /usr/sbin/mdata-get sdc:hostname > /etc/salt/minion_id; systemctl disable firewalld"
