kubeadm-etcd-generate-manifest:
  cmd.run:
    - name: kubeadm init phase etcd local --config=/etc/kubernetes/kubeadm-etcd.yaml
    - creates: /etc/kubernetes/manifests/etcd.yaml
