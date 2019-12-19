kubernetes-admin-service-account:
  file.managed:
    - name: /deploy/kubernetes/sa.yaml
    - source: salt://kubernetes/sa.yaml

kubernetes-apply-admin-service-account:
  cmd.wait:
    - name: kubectl apply --kubeconfig /etc/kubernetes/admin.conf -f /deploy/kubernetes/sa.yaml
    - watch:
        - file: kubernetes-admin-service-account
