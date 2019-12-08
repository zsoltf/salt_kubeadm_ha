{% set cluster_mine = salt['mine.get']('kube-etcd*', 'ip') | dictsort() %}
{% set cluster = [] %}
{% for name, host in cluster_mine %}
  {% do cluster.append(name ~ "=https://" ~ host[0] ~ ":2380") %}
{% endfor %}

{% set host = grains['fqdn_ip4']|first %}
{% set name =  grains['id'] %}
