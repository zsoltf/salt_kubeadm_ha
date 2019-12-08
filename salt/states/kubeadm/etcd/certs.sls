etcd-certificates:
  file.recurse:
    - name: /etc/kubernetes
    - source: salt://minionfs/kube-etcd-1.{{ grains['domain'] }}/deploy/{{ grains['id'] }}
    - show_changes: False
    - keep_source: False
