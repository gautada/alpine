#!/bin/sh
#
# profile: This script is called from `/etc/profile.d/base-profile.sh`. This
#          sets up the default functions and aliases for all containers.
#
# author: adam@gautier.org
# date: 2022-11-16
# component: environment
#
# - - - - - - - - - - - - - - - - - - - - - - -



alias osversion='cat /etc/alpine-release'
alias version='/usr/bin/container-version'

# echo "_ALSV=$(osversion)" > /etc/container/.alsv

log() {
 DEBUG="[D]"
 INFO="[I]"
 WARN="[W]"
 ERROR="[E]"

 TIMESTAMP="$(/bin/date '+%h %d %H:%M:%S')"
 LEVEL="$DEBUG"
 OPTION=$1
 case ${OPTION} in
  -e) LEVEL="$ERROR"
  ;;
  -w) LEVEL="$WARN"
  ;;
  -i) LEVEL="$INFO"
  ;;
  -d) LEVEL="$DEBUG"
  ;;
 esac

 COMPONENT="$2"
 MSG="$3"
 LOG_MSG="$TIMESTAMP container $COMPONENT:$LEVEL-$MSG"
 echo $LOG_MSG
}

