{% load_yaml as defaults_map %}

  base:
    owner: zsolt
    brand: kvm
    images:
      ubuntu: 9aa48095-da9d-41ca-a094-31d1fb476b98

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
