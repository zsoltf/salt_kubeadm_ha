{% set first_etcd = salt['mine.get']('kube:role:etcd', 'test.ping', 'grain') | dictsort() | first | first %}

kubeadm-etcd-certificates:
  file.recurse:
    - name: /etc/kubernetes
    - source: salt://minionfs/{{ first_etcd }}.{{ grains['domain'] }}/deploy/{{ grains['id'] }}
    - source: salt://minionfs/{{ first_etcd }}/deploy/{{ grains['id'] }}
    #- show_changes: False
    - keep_source: False

kubeadm-etcd-generate-manifest:
  cmd.run:
    - name: kubeadm init phase etcd local --config=/etc/kubernetes/kubeadm-etcd.yaml
    - creates: /etc/kubernetes/manifests/etcd.yaml
    - require:
        - file: kubeadm-etcd-certificates

etcd-kubelet-config:
  file.managed:
    - name: /etc/kubernetes/kubelet.yaml
    - contents: |
        apiVersion: kubelet.config.k8s.io/v1beta1
        kind: KubeletConfiguration
        address: 127.0.0.1
        podManifestPath: /etc/kubernetes/manifests
        cgroupDriver: systemd
