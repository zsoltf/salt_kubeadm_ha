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

echo '**** salt'
multipass launch -c 2 -n salt --cloud-init cloud-init/salt.yaml && \
multipass mount ../ salt:/srv/ && \
multipass exec salt -- sudo cp /srv/test/master.conf /etc/salt/master.d/ && \
multipass exec salt -- sudo service salt-master restart && \
sleep 5 && \
multipass exec salt -- sudo salt-key

echo
