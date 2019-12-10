{% set grains =  pillar['kubernetes']['grains'] %}

hypervisor-grains:
  grains.present:
    - name: hyper
    - value: {{ grains }}
