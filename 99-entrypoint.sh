#!/bin/ash

# Execute the parameters provided
RETURN_VALUE=0
if [ ! -z "$ENTRYPOINT_PARAMS" ] ; then
 exec $ENTRYPOINT_PARAMS
 RETURN_VALUE $?
else
 # Kill the background crond and restart with the forground service.  Crond is the default
 # container process.
 TEST="$(/usr/bin/pgrep crond)"
 if [ $? -eq 0 ] ; then
  # Kill the background cron service
  kill "$(/usr/bin/pgrep crond)"
 fi
 echo "---------- [ SCHEDULER(*crond) ] ----------"
 /usr/bin/sudo /usr/sbin/crond -f -l 0
 fi
 unset TEST
fi
unset ENTRYPOINT_PARAM
return $RETURN_VALUE
