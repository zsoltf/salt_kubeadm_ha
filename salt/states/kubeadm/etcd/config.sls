kubeadm-etcd-generate-manifest:
  cmd.run:
    - name: kubeadm init phase etcd local --config=/etc/kubernetes/kubeadm-etcd.yaml
    - creates: /etc/kubernetes/manifests/etcd.yaml

kubeadm-etcd-certificates:
  file.recurse:
    - name: /etc/kubernetes
    - source: salt://minionfs/kube-etcd-1.{{ grains['domain'] }}/deploy/{{ grains['id'] }}
    #- show_changes: False
    - keep_source: False

etcd-kubelet-config:
  file.managed:
    - name: /etc/kubernetes/kubelet.yaml
    - contents: |
        apiVersion: kubelet.config.k8s.io/v1beta1
        kind: KubeletConfiguration
        address: 127.0.0.1
        podManifestPath: /etc/kubernetes/manifests
        cgroupDriver: systemd
