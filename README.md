# Salt Kubeadm HA

Create highly available Kubernetes clusters with Kubeadm and Salt.

This state follows the official [kubeadm guide for HA clusters](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/) as close as possible.

It can bootstrap VMs on bare metal with SmartOS or existing VMs joined to a salt master can be used.

Works with Ubuntu VMs. Centos/Fedora support will be added later.

## Quickstart

### Requirements

A salt master and at least 11 VMs that are named `kube-role-number` with grains `kube:role:rolename` set.

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

### Bare Metal

Create a cluster of VMs on three or more bare metal machines using SmartOS. VMs can be KVM or bhyve based on cpu support.

Set datacenter grain
```
salt 'frigate-*' grains.set datacenter us-west-1
```

Edit Kubernetes pillar
```
$EDITOR salt/pillar/kubernetes.sls
```

Edit grains pillar for roles and placement groups
```
$EDITOR salt/pillar/grains.sls
```

Define VM size and type for each datacenter
```
$EDITOR salt/pillar/zones/*
```

Verify pillar, grains and mine data
```
salt '*' mine.get '*' ip
salt '*' pillar.items
salt '*' grains.item datacenter
```

Create KVM/Bhyve zones
```
salt-run state.orch orchestrate.zones
```

Create a Kubernetes cluster
```
salt-run state.orch orchestrate.kube
```

Or run in steps:
Bootstrap a blank cluster
```
salt-run state.orch orchestrate.kubeadm
```
Apply addons and user accounts
```
salt-run state.orch orchestrate.kubernetes
```


### Existing VMs

Set Grains
```
salt 'kube-etcd-*' grains.set kube:role etcd
salt 'kube-lb-*' grains.set kube:role lb
salt 'kube-master-*' grains.set kube:role master
salt 'kube-worker-*' grains.set kube:role worker
```

Cloud-init example see `test/cloud-init`

Set Pillars
`$EDITOR salt/pillar/kubernetes.sls`

Verify Mine
```
salt-call mine.get '*' ip
```

Orchestrate
```
salt-run state.orch orchestrate.kube
```

Or run in steps:
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
- apt mirror
- orchestrate on kvm clusters
- redhat support
