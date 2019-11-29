etcd-service-manager:
  file.managed:
    - name: /etc/systemd/system/kubelet.service.d/20-etcd-service-manager.conf
    - makedirs: True
    - contents: |
        [Service]
        ExecStart=
        #  Replace "systemd" with the cgroup driver of your container runtime. The default value in the kubelet is "cgroupfs".
        ExecStart=/usr/bin/kubelet --address=127.0.0.1 --pod-manifest-path=/etc/kubernetes/manifests --cgroup-driver=systemd
        Restart=always


etcd-update-kubelet:
  cmd.wait:
    - name: 'systemctl daemon-reload && systemctl restart kubelet'
    - watch:
        - file: etcd-service-manager
