{% if salt['pillar.get']('grains:hyper') %}

hypervisor-grains:
  grains.present:
    - name: hyper
    - value: {{ salt['pillar.get']('grains:hyper') }}

{% endif %}
