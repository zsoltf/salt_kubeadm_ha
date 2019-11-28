testo:
  test.nop:
    - name: {{ pillar.get('hello') }}
    - hello: world

vmtest.example.org:
  smartos.vm_present:
    - config:
        auto_import: true
        reprovision: true
    - vmconfig:
        image_uuid: 3dbbdcca-2eab-11e8-b925-23bf77789921
        brand: lx
        alias: vmtest
        quota: 5
        max_physical_memory: 512
        tags:
          label: 'test vm'
          owner: 'zsolt'
        nics:
          - nic_tag: admin
            mtu: 1500
            ips:
              - dhcp
