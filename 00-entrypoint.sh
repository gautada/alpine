#!/bin/ash

source /etc/entrypoint.conf

# Luanch the ssh bastion and podman API Service.


# /usr/bin/sudo /usr/bin/ssh-keygen -A -f /opt/bastion/

# Check if bastion folder is provided and the server key folder is provided
if [ -d /opt/bastion/etc/ssh ] ; then
 echo "---------- [ BASTION(sshd) ] ----------"
 if [ -f "/opt/bastion/ssh/authorized_keys" ] ; then
  /usr/bin/sudo /usr/sbin/sshd -e -E /var/log/bastion.log -f /etc/ssh/sshd_config
 fi
fi

# fi
# Check is host keys (try just RSA key) are available otherwise generate keys
# if [ ! -f /opt/bastion/ssh_host_rsa_key ] ; then
#  /usr/bin/sudo /usr/bin/ssh-keygen -A -f /opt/bastion/
# fi

# Check if bastion folder is available
# Check if server keys are generated, if no cannot start
# loop through all home folders
# if no ~/.ssh folder, skip
# if .ssh folder then load the authorized keys into bastion_keys
# https://stackoverflow.com/questions/68625039/ssh-authorized-keys-file-location-and-permissions
# Check that server side keys are generated

# if [ -f /opt/podman-data/authorized_keys ] ; then
#  if [ ! -d /home/podman/.ssh ] ; then
#   mkdir -p /home/podman/.ssh
#  fi
#  # /usr/bin/ssh-keygen -f /home/bob/.ssh/podman_key -N ''
#  cp /opt/podman-data/authorized_keys /home/podman/.ssh/authorized_keys
#  chmod 0700 ~/.ssh
#  chmod 0600 ~/.ssh/*
# fi
# Launch sshd
# /usr/bin/sudo /usr/sbin/sshd -e -f /etc/ssh/sshd_config


## Launch the cron service. By default this is in the daemon(background) mode unless defined in
## `/etc/entrypoint.conf`. If CMD parameters are defined then force cron to run in background
## to allow for the CMD to be executed.
if [ "default" == "$1" ] ; then
  /usr/bin/sudo /usr/sbin/crond -f -l 0
else
 echo "---------- [ SCHEDULER(crond) ] ----------"
  /usr/bin/sudo /usr/sbin/crond -b -l 0 -L /var/log/scheduler.log
fi

# if [ -z $EP_SCHEDULER ] ; then
#
#  exec $EP_SCHEDULER
# fi
# else
#   echo "DEFAULT $@"
#
# fi
