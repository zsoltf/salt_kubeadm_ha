{% load_yaml as defaults_map %}

  base:
    owner: zsolt
    brand: kvm
    images:
      ubuntu: 9aa48095-da9d-41ca-a094-31d1fb476b98
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDThfGA6c88VJPeqJHSRlQT8GplLGUXidtHc+3L4zHHu31H5By2yRnWEnCB1+MXgmP41kFhu1ZKa6TfvrbDXVsXj7awQt0d45RP9mKcKTMCKK41PXap78bsz9QcNdYVI1UP3BGEQRxrrIo3QINVzgz1cu9Wqwcer03KA4pf/6givvYCAEUr9U5/HC6BoBzqS1CxrUVVOuL9lCrVaFZOXN0fldsjXNn2CYjIDxvST1oygOB7lfIaS61HS3mBfrqCvTrg+uFZYybvlrvMGBkIox+RVSRve+hZ0nAsJj+FG7owT6QN3Ncyrcrf7aRSOXYGRA5Uvx5UH6JQoBDwKVpWai+x kryten@trusty
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCr8LopRSIg+Ng7oWqEqfxcXL+Ly8FK3E1A/RMvMHOOSV7zXCrqZnFhtXA3PByYG0xXRJjI2G2Kt0OwCR6UWfRSom/GIXuZQUyd8fq6QaceY+L7SnyekLRsfpTaJ6hxQoxCi18tiIMJQhp21reclyJ9up1Sncju75y1T2aI9Gu035TYBFGs9kiGOz+MI25TDiUKmXML9UcWaOzTtt2WQopV9i0sYHtSFeOKT3UCqtjCzy/tx9iOn8c0Hzzpm/7L8KPBlOZXCit2NlmWjWzX+fhdGt/i2NOmpZ1Ni0bX4FRwvTTJevdl8KPm0Epef/63wOAoKER5F0lY3BgKYwTdfshn zsolt@hyperion

  carrier-1*:
    brand: bhyve

{% endload %}
{% set defaults = salt['grains.filter_by'](defaults_map, grain='id', base='base') %}

{% macro apply_placement(zones) -%}
zones:
{%- for name, zone in zones.items() if zone['placement'] in grains['hyper']['placements'] %}
  {{ name|yaml }}: {{ zone|yaml }}
{% endfor -%}
{%- endmacro %}


zone:
  defaults: {{ defaults|yaml }}
