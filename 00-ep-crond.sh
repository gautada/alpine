#!/bin/ash
#
# Container Entrypoint
#
# Clear old backups
 echo "---------- [ BACKUP(duplicity) ] ----------"
/bin/rm -rf /opt/backup/duplicity*

# Launch schedular
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

