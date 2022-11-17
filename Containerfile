ARG ALPINE_VERSION=3.16.2

# ╭――――――――――――――――---------------------------------------------------------――╮
# │                                                                           │
# │ STAGE 1: alpine-container                                                 │
# │                                                                           │
# ╰―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――╯
FROM alpine:$ALPINE_VERSION

# ╭――――――――――――――――――――╮
# │ METADATA           │
# ╰――――――――――――――――――――╯
LABEL version="2022-11-17"
LABEL source="https://github.com/gautada/alpine-container.git"
LABEL maintainer="Adam Gautier <adam@gautier.org>"
LABEL description="Alpine Linux base container."

# ╭――――――――――――――――――――╮
# │ BACKUP             │
# ╰――――――――――――――――――――╯
COPY container-backup /usr/bin/container-backup
COPY backup /etc/container/backup
RUN /bin/mkdir -p /var/backup /tmp/backup /mnt/volumes/backup /mnt/volumes/configmaps \
 && ln -fsv /usr/bin/container-backup /etc/periodic/hourly/container-backup \
 && ln -fsv /mnt/volumes/container/backup.key /mnt/volumes/configmaps/backup.key \
 && ln -fsv /mnt/volumes/configmaps/backup.key /etc/container/backup.key
 
# ╭――――――――――――――――――――╮
# │ ENTRYPOINT         │
# ╰――――――――――――――――――――╯
RUN /bin/ln -fsv /mnt/volumes/container/entrypoint /etc/container/entrypoint
COPY container-entrypoint /usr/bin/container-entrypoint
ENTRYPOINT ["/usr/bin/container-entrypoint"]

# ╭――――――――――――――――――――╮
# │ ENVIRONMENT        │
# ╰――――――――――――――――――――╯
ENV ENV="/etc/profile"
COPY _profile /etc/container/.profile
COPY profile /etc/container/profile
RUN /bin/ln -fsv /etc/container/.profile /etc/profile.d/base-profile.sh
RUN /bin/ln -fsv /etc/container/profile /etc/profile.d/container-profile.sh

# ╭――――――――――――――――――――╮
# │ PACKAGES           │
# ╰――――――――――――――――――――╯
RUN /sbin/apk add --no-cache bind-tools curl duplicity iputils nano nmap nmap-ncat shadow sudo tzdata wget

# ╭――――――――――――――――――――╮
# │ PRIVILEGE          │
# ╰――――――――――――――――――――╯
COPY _wheel /etc/container/.wheel
RUN /bin/ln -fsv /etc/container/.wheel /etc/sudoers.d/_wheel \
 && /bin/ln -fsv /etc/container/wheel /etc/sudoers.d/wheel

# ╭――――――――――――――――――――╮
# │ STATUS             │
# ╰――――――――――――――――――――╯
# Conforms to the status component design.
COPY container-status-check /usr/bin/container-status-check
COPY health-check /etc/container/health-check
COPY status-check /etc/container/status-check
RUN /bin/ln -fsv /usr/bin/container-status-check /usr/bin/container-health-check \
 && /bin/ln -fsv /usr/bin/container-status-check /usr/bin/container-liveness-check \
 && /bin/ln -fsv /usr/bin/container-status-check /usr/bin/container-readiness-check \
 && /bin/ln -fsv /usr/bin/container-status-check /usr/bin/container-startup-check \
 && /bin/ln -fsv /etc/container/health-check /etc/container/liveness-check \
 && /bin/ln -fsv /etc/container/health-check /etc/container/readiness-check \
 && /bin/ln -fsv /etc/container/health-check /etc/container/startup-check 
HEALTHCHECK --interval=10m --timeout=60s --start-period=5m --retries=10 CMD /usr/bin/container-health-check

# ╭――――――――――――――――――――╮
# │ TIMEZONES          │
# ╰――――――――――――――――――――╯
RUN /bin/cp -v /usr/share/zoneinfo/America/New_York /etc/localtime
RUN /bin/echo "America/New_York" > /etc/timezone

# ╭――――――――――――――――――――╮
# │ VERSION            │
# ╰――――――――――――――――――――╯
COPY version /usr/bin/container-version

# ╭――――――――――――――――――――╮
# │ VOLUMES            │
# ╰――――――――――――――――――――╯
RUN /bin/mkdir -p /mnt/volumes/backup /mnt/volumes/configmaps /mnt/volumes/container


















# RUN mkdir /etc/container/configmap.d /etc/container/keys.d
# USER root
# WORKDIR /
