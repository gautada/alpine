#!/bin/ash

# source /etc/entrypoint.conf
# Luanch the ssh bastion and podman API Service.

# /usr/bin/sudo /usr/bin/ssh-keygen -A -f /opt/bastion/

# Check if bastion folder is provided and the server key folder is provided
# if [ -d /opt/bastion/ssh ] ; then
 # /bin/chown -R "$(/usr/bin/whoami)":"$(/usr/bin/whoami)" /opt/bastion/ssh
 # /bin/chmod 0700 /opt/bastion/ssh
 # /bin/chown $USER:USER /opt/bastion/ssh/authorized_keys
 # /bin/chmod 0600 /opt/bastion/ssh/authorized_keys
# fi
if [ -d /opt/bastion/etc/ssh ] ; then
 if [ -f "/opt/bastion/ssh/authorized_keys" ] ; then
  echo "---------- [ BASTION(sshd) ] ----------"
  /usr/bin/sudo /usr/sbin/sshd -e -E /var/log/bastion.log -f /etc/ssh/sshd_config
 fi
fi
# https://stackoverflow.com/questions/68625039/ssh-authorized-keys-file-location-and-permissions

## Launch the cron service. By default this is in the daemon(background) mode unless defined in
## `/etc/entrypoint.conf`. If CMD parameters are defined then force cron to run in background
## to allow for the CMD to be executed.
if [ "default" == "$1" ] ; then
  /usr/bin/sudo /usr/sbin/crond -f -l 0
else
 echo "---------- [ SCHEDULER(crond) ] ----------"
  /usr/bin/sudo /usr/sbin/crond -b -l 0 -L /var/log/scheduler.log
fi
