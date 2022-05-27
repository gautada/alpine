#!/bin/ash
#
# Scheduler entrypoint
#
# echo "... [$0] ..."
# Scheduler should always launch in the background (it will get corrected later (99) if it gets that far)
TEST="$(/usr/bin/pgrep /usr/sbin/crond)"
if [ $? -eq 1 ] ; then
 echo "---------- [ SCHEDULER(crond) ] ----------"
 /usr/bin/sudo /usr/sbin/crond -b -l 0 -L /var/log/scheduler.log
else
 echo "GOO"
 /usr/bin/pgrep crond
echo "$?"
fi
unset TEST

