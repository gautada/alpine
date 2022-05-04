#!/bin/ash

source /etc/entrypoint.conf

# Luanch the ssh bastion and podman API Service.

echo "---------- [ BASTION(sshd) ] ----------"
# Check is host keys (try just RSA key) are available otherwise generate keys
if [ ! -f /etc/ssh/ssh_host_rsa_key ] ; then
 /usr/bin/sudo /usr/bin/ssh-keygen -A
fi
# Check that server side keys are generated
if [ -f /opt/podman-data/authorized_keys ] ; then
 if [ ! -d /home/podman/.ssh ] ; then
  mkdir -p /home/podman/.ssh
 fi
 # /usr/bin/ssh-keygen -f /home/bob/.ssh/podman_key -N ''
 cp /opt/podman-data/authorized_keys /home/podman/.ssh/authorized_keys
 chmod 0700 ~/.ssh
 chmod 0600 ~/.ssh/*
fi
# Launch sshd
/usr/bin/sudo /usr/sbin/sshd -e -f /etc/ssh/sshd_config


## Launch the cron service. By default this is in the daemon(background) mode unless defined in
## `/etc/entrypoint.conf`. If CMD parameters are defined then force cron to run in background
## to allow for the CMD to be executed.
echo "---------- [ SCHEDULER(crond) ] ----------"
if [ -z $@ ] ; then
 /usr/bin/sudo /usr/sbin/crond $ENTRYPOINT_CROND
else
  echo "DEFAULT $@"
  /usr/bin/sudo /usr/sbin/crond -b
fi
