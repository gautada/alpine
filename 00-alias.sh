#!/bin/ash
#
# This script sets two alias for printing the os and container version
#

# There are various choice to get the os version on Alpine Linux.

# osversion() {
 # Mechanism One
 # source /etc/os-release
 # echo "$VERSION_ID"
 #
 # Mechanism Two
 # /usr/bin/awk -F= '$1=="VERSION_ID" {print $2}' /etc/os-release ;
 #
 # Mechanism 3
# cat /etc/alpine-relase
#}
alias osversion='cat /etc/alpine-release'
alias cversion='osversion'
