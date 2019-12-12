#!/bin/bash

BS_HOST=$1
EXIT=0

echo "$BS_HOST - Bootstrap Start"

echo "$BS_HOST - ssh-copy-id"
ssh-copy-id root@${BS_HOST}

echo "$BS_HOST - Creating Dirs"
ssh root@${BS_HOST} mkdir -p /opt/custom/{salt,smf,scripts} /usbkey/config.inc
EXIT=$(( $EXIT + $? ))

echo "$BS_HOST - Add SSH Keys"
cat ~/.ssh/id*.pub | ssh root@${BS_HOST} 'cat -> /usbkey/config.inc/authorized_keys'
EXIT=$(( $EXIT + $? ))

echo "$BS_HOST - Configure SSH Authorized Key"
ssh root@${BS_HOST} 'grep "keys" /usbkey/config > /dev/null'

if [ $? == '1' ]; then
    echo root_authorized_keys_file=authorized_keys | ssh root@${BS_HOST} 'cat ->> /usbkey/config'
else
    echo "$BS_HOST - SSH Authorized Key alredy configured"
fi

echo "$BS_HOST - Copying Pkg Script"
scp package.sh root@${BS_HOST}:/opt/custom/scripts/
EXIT=$(( $EXIT + $? ))

echo "$BS_HOST - Installing Pkg Repo"
ssh root@${BS_HOST} /opt/custom/scripts/package.sh
EXIT=$(( $EXIT + $? ))

echo "$BS_HOST - Installing Salt"
ssh root@${BS_HOST} /opt/tools/bin/pkgin -y install salt
EXIT=$(( $EXIT + $? ))

echo "$BS_HOST - Uploading Salt Service Manifest"
scp salt.xml root@${BS_HOST}:/opt/custom/smf/
EXIT=$(( $EXIT + $? ))

echo "$BS_HOST - Uploading Salt Minion Config"
scp minion root@${BS_HOST}:/opt/tools/etc/salt/minion
EXIT=$(( $EXIT + $? ))

echo "$BS_HOST - Enabling Salt Minion"
ssh root@${BS_HOST} svcadm enable salt:minion
EXIT=$(( $EXIT + $? ))

if [ $EXIT == "0" ]; then
    echo "$BS_HOST - Bootstrap success"
else
    echo "$BS_HOST - Bootstrap failed"
fi

exit $EXIT
