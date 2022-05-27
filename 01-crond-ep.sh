#!/bin/ash
#
# Scheduler entrypoint
#

# Scheduler should always launch in the background (it will get corrected later (99) if it gets that far)
TEST="$(/usr/bin/pgrep crond)"
if [ $? -eq 1 ] ; then
 echo "---------- [ SCHEDULER(crond) ] ----------"
 /usr/bin/sudo /usr/sbin/crond -b -l 0 -L /var/log/scheduler.log
fi
unset TEST

