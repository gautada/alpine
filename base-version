#!/bin/sh
# Script that provides the container version scheme. As the 
# container version is a complex thing meaning that it is 
# a  
os_name() {
 echo "alpine"
}

os_version() {
 /bin/cat /etc/alpine-release
}

os_build() {
 /bin/cat /etc/alpine-build
}

base_version() {
 echo "$(os_name)-$(os_version).$(os_build)"
}

container_name() {
 /bin/cat /etc/container/name
}

container_build() {
 /bin/cat /etc/container/build	
}