etcd-service-manager:
  file.managed:
    - name: /etc/systemd/system/kubelet.service.d/20-etcd-service-manager.conf
    - makedirs: True
    - contents: |
        [Service]
        ExecStart=
        ExecStart=/usr/bin/kubelet --address=127.0.0.1 --pod-manifest-path=/etc/kubernetes/manifests --cgroup-driver=systemd --container-runtime-endpoint=unix:///run/containerd/containerd.sock
        Restart=always

#ExecStart=/usr/bin/kubelet --config=/etc/kubernetes/kubelet.yaml

etcd-update-kubelet:
  cmd.wait:
    - name: 'systemctl daemon-reload && systemctl restart kubelet'
    - watch:
        - file: etcd-service-manager
