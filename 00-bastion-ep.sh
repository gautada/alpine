#!/bin/ash
#
# Bastion Entrypoint
#
if [ -d /opt/bastion/etc/ssh ] ; then
 if [ -f "/opt/bastion/ssh/authorized_keys" ] ; then
  # Make sure another sshd is not already running
  TEST="$(/usr/bin/pgrep sshd)"
  if [ $? -eq 1 ] ; then
   echo "---------- [ BASTION(sshd) ] ----------"
   /usr/bin/sudo /usr/sbin/sshd -e -E /var/log/bastion.log -f /etc/ssh/sshd_config
  fi
  unset TEST
 fi
fi
