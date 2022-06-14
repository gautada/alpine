#!/bin/ash

container_backup() {
 pwd
 echo "[ WARN] This function should be overloaded by the container"
 date > alpine-backup.txt
 FOLDER=$(date +%s)
 mkdir $FOLDER
 date > $FOLDER/another-backup.txt
}
