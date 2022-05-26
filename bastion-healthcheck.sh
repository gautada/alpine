#!/bin/ash

# Default health is zero which equals healthy
HEALTH=0

# Check - SSHD Daemon - running is healthy
  TEST="$(/usr/bin/pgrep sshd)"
if [ $? -eq 1 ] ; then
 HEALTH=1
fi

return $HEALTH

