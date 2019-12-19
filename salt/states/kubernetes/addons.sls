kubernetes-cluster-addons:
  file.recurse:
    - name: /deploy/kubernetes/addons
    - makedirs: True
    - source: salt://kubernetes/addons
    - keep_source: False

kubernetes-install-cluster-addons:
  cmd.wait:
    - name: kubectl apply --kubeconfig /etc/kubernetes/admin.conf -f /deploy/kubernetes/addons
    - watch:
        - file: kubernetes-cluster-addons
