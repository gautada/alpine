ARG ALPINE_VERSION=3.15.4

# ╭――――――――――――――――---------------------------------------------------------――╮
# │                                                                           │
# │ STAGE 1: alpine-container                                                 │
# │                                                                           │
# ╰―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――╯
FROM alpine:$ALPINE_VERSION

# ╭――――――――――――――――――――╮
# │ METADATA           │
# ╰――――――――――――――――――――╯
LABEL version="2022-04-29"
LABEL source="https://github.com/gautada/alpine-container.git"
LABEL maintainer="Adam Gautier <adam@gautier.org>"
LABEL description="Based container as a basic Alpine Linux distribution for use as the core for other containers."

# ╭――――――――――――――――――――╮
# │ ENVIRONMENT        │
# ╰――――――――――――――――――――╯
ENV ENV="/etc/profile"
RUN mkdir -p /etc/container \
 && ln -s /etc/profile.d /etc/container/profile.d
COPY version /bin/version
COPY 00-alias.sh /etc/container/profile.d/00-alias.sh
RUN mkdir /etc/container/configmap.d /etc/container/keys.d
USER root
WORKDIR /

# ╭――――――――――――――――――――╮
# │ BACKUP             │
# ╰――――――――――――――――――――╯
COPY backup.fnc /etc/container/backup.d/backup.fnc
COPY container-backup /usr/sbin/container-backup
RUN mkdir -p /etc/container/keys.d /var/backup /tmp/backup /opt/backup \
 && ln -s /usr/sbin/container-backup /etc/periodic/hourly/container-backup \
 && ln -s /opt/backup/backup-encryption.key /etc/container/keys.d/backup-encryption.key
 

# ╭――――――――――――――――――――╮
# │ HEALTHCHECK        │
# ╰――――――――――――――――――――╯
COPY healthcheck /healthcheck
COPY hc-crond.sh /etc/container/healthcheck.d/hc-crond.sh
COPY container-healthcheck /usr/sbin/container-healthcheck
HEALTHCHECK --interval=10m --timeout=60s --start-period=5m --retries=10 CMD /healthcheck

# ╭――――――――――――――――――――╮
# │ PACKAGES           │
# ╰――――――――――――――――――――╯
RUN /sbin/apk add --no-cache bind-tools curl duplicity iputils nano nmap nmap-ncat shadow sudo tzdata wget
# RUN /sbin/apk add --no-cache python3

# ╭――――――――――――――――――――╮
# │ SUDO               │
# ╰――――――――――――――――――――╯
RUN ln -s /etc/sudoers.d /etc/container/wheel.d
COPY wheel-crond /etc/container/wheel.d/wheel-crond
COPY wheel-nmap /etc/container/wheel.d/wheel-nmap
COPY wheel-backup /etc/container/wheel.d/wheel-backup

# ╭――――――――――――――――――――╮
# │ TIMEZONES          │
# ╰――――――――――――――――――――╯
RUN /bin/cp -v /usr/share/zoneinfo/America/New_York /etc/localtime
RUN /bin/echo "America/New_York" > /etc/timezone

# ╭――――――――――――――――――――╮
# │ ENTRYPOINT         │
# ╰――――――――――――――――――――╯
COPY entrypoint /entrypoint
COPY 00-ep-crond.sh /etc/container/entrypoint.d/00-ep-crond.sh
COPY 10-ep-container.sh /etc/container/entrypoint.d/10-ep-container.sh
COPY 99-ep-exec.sh /etc/container/entrypoint.d/99-ep-exec.sh
# COPY exitpoint /exitpoint
# RUN mkdir -p /etc/container/exitpoint.d
ENTRYPOINT ["/entrypoint"]


 
