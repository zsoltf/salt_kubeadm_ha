### create vms ###

{% load_yaml as kvm_states %}

# for kvm
create-etcd-1-node:
  salt.function:
    - name: state.sls_id
    - tgt: 'frigate-1*'
    - arg:
        - zone_kube-etcd-1
        - zones

create-etcd-2-node:
  salt.function:
    - name: state.sls_id
    - tgt: 'frigate-2*'
    - arg:
        - zone_kube-etcd-2
        - zones

create-etcd-3-node:
  salt.function:
    - name: state.sls_id
    - tgt: 'frigate-3*'
    - arg:
        - zone_kube-etcd-3
        - zones
create-lb-1-node:
  salt.function:
    - name: state.sls_id
    - tgt: 'frigate-1*'
    - arg:
        - zone_kube-lb-1
        - zones
    - require:
        - salt: create-etcd-1-node
        - salt: create-etcd-2-node
        - salt: create-etcd-3-node

create-lb-2-node:
  salt.function:
    - name: state.sls_id
    - tgt: 'frigate-2*'
    - arg:
        - zone_kube-lb-2
        - zones
    - require:
        - salt: create-etcd-1-node
        - salt: create-etcd-2-node
        - salt: create-etcd-3-node

create-lb-3-node:
  salt.function:
    - name: state.sls_id
    - tgt: 'frigate-3*'
    - arg:
        - zone_kube-lb-3
        - zones
    - require:
        - salt: create-etcd-1-node
        - salt: create-etcd-2-node
        - salt: create-etcd-3-node

create-master-1-node:
  salt.function:
    - name: state.sls_id
    - tgt: 'frigate-1*'
    - arg:
        - zone_kube-master-1
        - zones
    - require:
        - salt: create-lb-1-node
        - salt: create-lb-2-node
        - salt: create-lb-3-node

create-master-2-node:
  salt.function:
    - name: state.sls_id
    - tgt: 'frigate-2*'
    - arg:
        - zone_kube-master-2
        - zones
    - require:
        - salt: create-lb-1-node
        - salt: create-lb-2-node
        - salt: create-lb-3-node

create-master-3-node:
  salt.function:
    - name: state.sls_id
    - tgt: 'frigate-3*'
    - arg:
        - zone_kube-master-3
        - zones
    - require:
        - salt: create-lb-1-node
        - salt: create-lb-2-node
        - salt: create-lb-3-node

create-worker-1-node:
  salt.function:
    - name: state.sls_id
    - tgt: 'frigate-4*'
    - arg:
        - zone_kube-worker-1
        - zones
    - require:
        - salt: create-master-1-node
        - salt: create-master-2-node
        - salt: create-master-3-node


create-worker-2-node:
  salt.function:
    - name: state.sls_id
    - tgt: 'frigate-5*'
    - arg:
        - zone_kube-worker-2
        - zones
    - require:
        - salt: create-master-1-node
        - salt: create-master-2-node
        - salt: create-master-3-node

create-worker-3-node:
  salt.function:
    - name: state.sls_id
    - tgt: 'frigate-6*'
    - arg:
        - zone_kube-worker-3
        - zones
    - require:
        - salt: create-master-1-node
        - salt: create-master-2-node
        - salt: create-master-3-node

{% endload %}

create-zones:
  salt.state:
    - tgt: 'os:SmartOS'
    - tgt_type: grain
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
