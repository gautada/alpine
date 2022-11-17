#!/bin/sh
#
# profile: This script is called from `/etc/profile.d/container-profile` and provides
#          container specific overide for environment variables. Please make sure to
#          overide the defaults below.
#
# author: adam@gautier.org
# date: 2022-11-16
# component: environment
#
# - - - - - - - - - - - - - - - - - - - - - - -

# Test that the base-profile is called first.
type osversion > /dev/null
RTN=$?
if [ $RTN -eq 0 ] ; then
 # Default(Change) - Call the cmd for container version
 alias cversion='osversion'
 # Default(Remove) - allow for customization using the container-volume
 if [ -f /mnt/volumes/container/profile ] ; then
  . /mnt/volumes/container/profile
 fi
else
 echo "[WARN] Unable to fine osversion function"
fi
