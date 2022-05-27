#!/bin/ash

# Default health is zero which equals healthy
HEALTH=0

# Check - CRON Daemon - running is healthy
TEST="$(/usr/bin/pgrep crond)"
if [ $? -eq 1 ] ; then
 HEALTH=1
fi

return $HEALTH
