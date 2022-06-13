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
COPY version /bin/version
COPY 00-profile.sh /etc/profile.d/00-profile.sh
USER root
WORKDIR /

# ╭――――――――――――――――――――╮
# │ BACKUP            │
# ╰――――――――――――――――――――╯
COPY container-backup /usr/sbin/container-backup
RUN mkdir -p /opt/backup/.cache /opt/backup/points \
 && ln -s /usr/sbin/container-backup /etc/periodic/hourly/container-backup  

# ╭――――――――――――――――――――╮
# │ HEALTHCHECK        │
# ╰――――――――――――――――――――╯
COPY healthcheck /healthcheck
COPY hc-crond.sh /etc/healthcheck.d/hc-crond.sh
HEALTHCHECK --interval=10m --timeout=60s --start-period=5m --retries=10 CMD /healthcheck

# ╭――――――――――――――――――――╮
# │ PACKAGES           │
# ╰――――――――――――――――――――╯
RUN /sbin/apk add --no-cache bind-tools curl duplicity iputils nano nmap nmap-ncat shadow sudo tzdata wget
# RUN /sbin/apk add --no-cache python3

# ╭――――――――――――――――――――╮
# │ SUDO               │
# ╰――――――――――――――――――――╯
COPY wheel-crond /etc/sudoers.d/wheel-crond
COPY wheel-nmap /etc/sudoers.d/wheel-nmap

# ╭――――――――――――――――――――╮
# │ TIMEZONES          │
# ╰――――――――――――――――――――╯
RUN /bin/cp -v /usr/share/zoneinfo/America/New_York /etc/localtime
RUN /bin/echo "America/New_York" > /etc/timezone

# ╭――――――――――――――――――――╮
# │ ENTRYPOINT         │
# ╰――――――――――――――――――――╯
COPY entrypoint /entrypoint
COPY 00-ep-crond.sh /etc/entrypoint.d/00-ep-crond.sh
COPY 10-ep-container.sh /etc/entrypoint.d/10-ep-container.sh
COPY 99-ep-exec.sh /etc/entrypoint.d/99-ep-exec.sh
COPY exitpoint /exitpoint
ENTRYPOINT ["/entrypoint"]
