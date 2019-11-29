google-cloud-repo:
  pkgrepo.managed:
    - humanname: Google Cloud
    - baseurl: https://packages.cloud.google.com/yum/repos/kubernetes-el7-$basearch
    - gpgcheck: 1
    - gpgkey: https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
