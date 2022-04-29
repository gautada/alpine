version() {
 /usr/bin/awk -F= '$1=="VERSION_ID" {print $2}' /etc/os-release ;
}
