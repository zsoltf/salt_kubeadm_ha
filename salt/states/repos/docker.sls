docker-ce-stable:
  pkgrepo.managed:
    - humanname: Docker CE Stable - $basearch
    - baseurl: https://download.docker.com/linux/centos/7/$basearch/stable
    - gpgcheck: 1
    - gpgkey: https://download.docker.com/linux/centos/gpg
