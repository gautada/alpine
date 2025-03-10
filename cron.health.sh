#!/bin/sh

__check() {
 _assert "0" "$(_proc_check cron)" "Active cron daemon"
}
