{% load_yaml as defaults %}

  owner: root
  brand: bhyve
  images:
    ubuntu: 9aa48095-da9d-41ca-a094-31d1fb476b98
  
{% endload %}

{% macro apply_placement(zones) -%}
zones:
{%- for name, zone in zones.items() if zone['placement'] in grains['kube']['placement'] %}
  {{ name|yaml }}: {{ zone|yaml }}
{% endfor -%}
{%- endmacro %}
