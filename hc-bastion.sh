#!/bin/ash

# Default health is zero which equals healthy
HEALTH=0

# Check - SSHD Daemon - running is healthy
if [ -d /opt/bastion/etc/ssh ] ; then
 if [ -f "/opt/bastion/ssh/authorized_keys" ] ; then
  TEST="$(/usr/bin/pgrep sshd)"
  if [ $? -eq 1 ] ; then
    HEALTH=1
  fi
 fi
fi

return $HEALTH

