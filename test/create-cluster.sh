#!/usr/bin/env bash

if which multipass > /dev/null; then
  echo lilu multipass
else
  echo install multipass with snap
  echo
  echo '    snap install multipass --classic'
  echo
  exit 1
fi

echo '**** etcd'
multipass launch -c 2 -m 1G -n kube-etcd-1 --cloud-init cloud-init/etcd.yaml &
multipass launch -c 2 -m 1G -n kube-etcd-2 --cloud-init cloud-init/etcd.yaml &
multipass launch -c 2 -m 1G -n kube-etcd-3 --cloud-init cloud-init/etcd.yaml &
echo '**** load balancers'
multipass launch -n kube-lb-1 --cloud-init cloud-init/lb.yaml &
multipass launch -n kube-lb-2 --cloud-init cloud-init/lb.yaml &
echo '**** masters'
multipass launch -c 2 -m 1G -n kube-master-1 --cloud-init cloud-init/master.yaml &
multipass launch -c 2 -m 1G -n kube-master-2 --cloud-init cloud-init/master.yaml &
multipass launch -c 2 -m 1G -n kube-master-3 --cloud-init cloud-init/master.yaml &
echo '**** workers'
multipass launch -c 2 -m 1G -n kube-worker-1 --cloud-init cloud-init/worker.yaml &
multipass launch -c 2 -m 1G -n kube-worker-2 --cloud-init cloud-init/worker.yaml &
multipass launch -c 2 -m 1G -n kube-worker-3 --cloud-init cloud-init/worker.yaml &
