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

echo '**** cleanup'

echo kube-etcd-1 kube-etcd-2 kube-etcd-3 \
  kube-lb-1 kube-lb-2 \
  kube-master-1 kube-master-2 kube-master-3 \
  kube-worker-1 kube-worker-2 kube-worker-3 | xargs -n1 multipass delete --purge
