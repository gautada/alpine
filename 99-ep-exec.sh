#!/bin/ash

echo "... [$0] ..."
# Execute the parameters provided from CLI

RETURN_VALUE=0
if [ ! -z "$ENTRYPOINT_PARAMS" ] ; then
 echo "---------- [ CONTAINER RUN($ENTRYPOINT_PARAMS) ] ----------"
 exec $ENTRYPOINT_PARAMS
 RETURN_VALUE $?
else
 # Kill the background crond and restart with the forground service.  Crond is the default
 # container process.
 TEST="$(/usr/bin/pgrep /usr/sbin/crond)"
 echo $TEST
 TEST="$(/usr/bin/pgrep /usr/sbin/crond)"
 if [ $? -eq 0 ] ; then
  # Kill the background cron service
  killall crond
 fi
 echo "---------- [ SCHEDULER(*crond) ] ----------"
 /usr/bin/sudo /usr/sbin/crond -f -l 0
 unset TEST
fi
unset ENTRYPOINT_PARAM
return $RETURN_VALUE
