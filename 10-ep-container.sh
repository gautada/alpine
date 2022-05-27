#!/bin/ash
#
# This is the example downstream entrypoint, launching either a container process or launch a
# container service. If launching a container process use `return 1` to block any subsequent
# entrypoint scripts.  Otherwise `return 0` for any container services to continue calling
# huigher numbered entrypoint scripts.
#
# DOWNSTREAM CONTAINERS SHOULD OVERWRITE THIS SCRIPT
# echo "... [$0] ..."
return 0
