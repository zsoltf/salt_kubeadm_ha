# Salt Kubeadm HA

Create highly available Kubernetes clusters with Kubeadm and Salt.

This state works with Ubuntu VMs. Centos/Fedora support will be added later.

See *salt_kubeadm_ha_cluster* for an example on how to create highly available clusters on bare metal.


## Quickstart

#### Requirements

Kubernetes nodes are named `kube-role-number` with grains `kube:role:rolename` set.

* Master with id `kube-master-\d.*` (kube-master-1, kube-master-2, kube-master-3)
* LB with id `kube-lb-\d.*` (kube-lb-1, etc)
* Etcd with id `kube-etcd-\d.*` (kube-etcd-1, etc)
* Worker with id `kube-worker-\d.*` (kube-worker-1, etc)

Salt Master settings:

```
file_recv: True
fileserver_backend:
  - roots
  - minionfs
minionfs_mountpoint: salt://minionfs
```


#### Set Grains

manually:
```
salt 'kube-etcd-*' grains.set kube:role etcd
salt 'kube-lb-*' grains.set kube:role lb
salt 'kube-master-*' grains.set kube:role master
salt 'kube-worker-*' grains.set kube:role worker
```

cloud-init example see `test/cloud-init`

#### Set Pillars

`$EDITOR salt/pillar/kubernetes.sls`

#### Verify Mine

```
salt-call mine.get '*' ip
```

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

## Test Cluster

Run the entire cluster locally with multipass on Ubuntu
```
cd test
./bootstrap-salt.sh
./create-cluster.sh
```

## Pillars

`salt/pillar/kubernetes.sls`
`salt/pillar/ip-mine.sls`


## States

### kubeadm
### kubernetes


## TODO
- ssh keys from pillar
- orchestrate on kvm clusters
- redhat support
