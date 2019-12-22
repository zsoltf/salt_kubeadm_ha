# Salt Kubeadm HA

Create highly available Kubernetes clusters with Kubeadm and Salt.

This state assumes the infrastructure is already set up and at least 4 VMs are joined to the salt master.

See *salt_kubeadm_ha_cluster* for an example on how to create highly available clusters on bare metal.


## Quickstart

#### Requirements

Kubernetes nodes are named `kube-role-number` with grains `kube:role:rolename` set.

* One or more Master with id `kube-master-\d.*` (kube-master-1, kube-master-2, kube-master-3)
* One or more LB with id `kube-lb-\d.*` (kube-lb-1, etc)
* One or more Etcd with id `kube-etcd-\d.*` (kube-etcd-1, etc)
* One or more Worker with id `kube-worker-\d.*` (kube-worker-1, etc)

Salt Master settings:

```
file_recv: True
fileserver_backend:
  - roots
  - minionfs
minionfs_mountpoint: salt://minionfs
```


Resources:

| machine       | count | cpu | memory |
|---------------|-------|-----|--------|
| load balancer |     2 |   2 |   1024 |
| etcd          |     3 |   2 |   2048 |
| master        |     3 |   2 |   2048 |
| worker        |     3 |   2 |   2048 |
|---------------|-------|-----|--------|
|               |    11 |   8 |   7168 |




#### Set Grains

```
salt 'kube-etcd-*' grains.set kube:role etcd
salt 'kube-lb-*' grains.set kube:role lb
salt 'kube-master-*' grains.set kube:role master
salt 'kube-worker-*' grains.set kube:role worker
```


#### Set Pillars

`salt/pillar/kube.sls`


#### Orchestrate

Bootstrap a kubernetes cluster with addons
```
salt-run state.orch orchestrate.kube
```

Run in steps:
Bootstrap a blank cluster
```
salt-run state.orch orchestrate.kubeadm
```
Apply addons and user accounts
```
salt-run state.orch orchestrate.kubernetes
```


## Pillars

`salt/pillar/kube.sls`
`salt/pillar/ip-mine.sls`


## States

### kubeadm
### kubernetes
