etcd-certificates:
  file.recurse:
    - name: /etc/kubernetes
    - source: salt://minionfs/kube-etcd-1/deploy/{{ grains.get('id') }}
    - show_changes: False
    - keep_source: False
