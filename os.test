#!/bin/sh

__os_stable_version() {
 curl --location --silent https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/aarch64 | grep alpine-release- | awk -F '-' '{print $3}' 
}

__os_running_version() {
 /bin/cat /etc/alpine-release
}

__check() {
 _assert "$(__os_stable_version)" "$(__os_running_version)" "OS Stable version must equal running version"
 _assert "$(_docker_latest_version 'library/alpine')" "$(__os_running_version)" "Docker latest image version must equal running version"
 _assert "$(_docker_latest_version 'gautada/alpine')" "$(__os_running_version)" "Container latest image version must equal running version"
}

