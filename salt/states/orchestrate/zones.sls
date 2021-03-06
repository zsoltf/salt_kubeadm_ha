### create vms ###

create-zones:
  salt.state:
    - tgt: 'G@os:SmartOS and G@datacenter:*'
    - tgt_type: compound
    - sls: zones

wait-for-minions:
  salt.wait_for_event:
    - name: salt/minion/*/start
    - id_list:
        - kube-etcd-1
        - kube-etcd-2
        - kube-etcd-3
        - kube-lb-1
        - kube-lb-2
        - kube-lb-3
        - kube-master-1
        - kube-master-2
        - kube-master-3
        - kube-worker-1
        - kube-worker-2
        - kube-worker-3
    - watch:
        - salt: create-zones
