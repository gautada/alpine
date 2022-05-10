#!/bin/ash
#
# Default base level container services"
# - Bastion(daemon) - sshd, ansible
# - Scheduler(daemon) - crond
#
# Launch the bastion container service (always in daemon/background)
# Check if bastion folder is provided and the server key folder is provided
echo "... [$0] ..."
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
# Scheduler should always launch in the background (it will get corrected later (99) if it gets that far)
TEST="$(/usr/bin/pgrep crond)"
if [ $? -eq 1 ] ; then
 echo "---------- [ SCHEDULER(crond) ] ----------"
 /usr/bin/sudo /usr/sbin/crond -b -l 0 -L /var/log/scheduler.log
fi
unset TEST

