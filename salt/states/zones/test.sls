{% set zones = salt['pillar.get']('zones', []) %}


{% for zone in zones %}

test_{{ loop.index }}:
  test.nop:
    - name: test
    - zone: {{ zone }}

{% endfor %}