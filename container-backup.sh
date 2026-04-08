#!/bin/sh

# Backup script calls the containers backup function and then archives 
# the backup data into the hour's tar ball.
set -xe

USER=$(awk -F':' -v uid=1001 '$3 == uid { print $1 }' /etc/passwd)
BACKUP="/tmp/backup"
CACHE="$BACKUP/cache"
/bin/mkdir -p $CACHE

/bin/chown 1001:1001 $CACHE
cd $CACHE

/bin/su "$USER" -c ". /etc/container/backup ; container_backup"

# Use unique identifier for backup filename to avoid collisions
if [ -n "$K8S_POD_NAME" ]; then
    INSTANCE_ID="$K8S_POD_NAME"
else
    INSTANCE_ID="$(/bin/hostname)"
fi

ARCHIVE="$BACKUP/$(/bin/date +%H)-$INSTANCE_ID.tgz"
/bin/tar  --create --gzip --file="$ARCHIVE" --verbose ./*
/bin/mv -v "$ARCHIVE" /mnt/volumes/backup/

