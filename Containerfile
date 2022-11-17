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
LABEL description="Alpine Linux base container."

# ╭――――――――――――――――――――╮
# │ ENTRYPOINT         │
# ╰――――――――――――――――――――╯
# RUN /bin/mkdir -p /etc/container.d \
#  && /bin/ln -svf /mnt/volumes/container/container-entrypoint /etc/container.d/container-entrypoint 
# COPY entrypoint /usr/bin/entrypoint
# ENTRYPOINT ["/usr/bin/entrypoint"]

# ╭――――――――――――――――――――╮
# │ PROFILE            │
# ╰――――――――――――――――――――╯
# ENV ENV="/etc/profile"
# COPY container-profile /etc/container.d/container-profile
# RUN /bin/ln -svf /etc/container.d/container-profile /etc/profile.d/container-profile \
#  && /bin/chmod +x /etc/container.d/container-profile

# ╭――――――――――――――――――――╮
# │ VERSION            │
# ╰――――――――――――――――――――╯
# COPY version /usr/bin/version
# RUN /bin/chmod +x /usr/bin/version

# ╭――――――――――――――――――――╮
# │ BACKUP             │
# ╰――――――――――――――――――――╯
# COPY container-backup /etc/container/backup
# COPY backup /usr/bin/backup
# RUN /bin/mkdir -p /var/backup /tmp/backup /mnt/volumes/backup \
#  && ln -s /usr/bin/backup /etc/periodic/hourly/backup \
#  && ln -s /mnt/volumes/backup/backup-encryption.key /etc/container/backup-encryption.key


# ╭――――――――――――――――――――╮
# │ VOLUMES            │
# ╰――――――――――――――――――――╯
# RUN /bin/mkdir -p /mnt/volumes/backup /mnt/volumes/configmaps /mnt/volumes/container 




# RUN mkdir /etc/container/configmap.d /etc/container/keys.d
# USER root
# WORKDIR /


 

# ╭――――――――――――――――――――╮
# │ STATUS             │
# ╰――――――――――――――――――――╯
# Conforms to the status component design.
COPY container-status-check /usr/bin/container-status-check
COPY health-check /etc/container/health-check
RUN /bin/ln -fsv /usr/bin/container-status-check /usr/bin/container-health-check \
 && /bin/ln -fsv /usr/bin/container-status-check /usr/bin/container-liveness-check \
 && /bin/ln -fsv /usr/bin/container-status-check /usr/bin/container-readiness-check \
 && /bin/ln -fsv /usr/bin/container-status-check /usr/bin/container-startup-check \
 && /bin/ln -fsv /etc/container/health-check /etc/container/liveness-check \
 && /bin/ln -fsv /etc/container/health-check /etc/container/readiness-check \
 && /bin/ln -fsv /etc/container/health-check /etc/container/startup-check 
HEALTHCHECK --interval=10m --timeout=60s --start-period=5m --retries=10 CMD /usr/bin/container-health-check

# ╭――――――――――――――――――――╮
# │ PACKAGES           │
# ╰――――――――――――――――――――╯
RUN /sbin/apk add --no-cache bind-tools curl duplicity iputils nano nmap nmap-ncat shadow sudo tzdata wget

# ╭――――――――――――――――――――╮
# │ PRIVILEGE          │
# ╰――――――――――――――――――――╯
# Create the container-wheel chain destination >> container config >> container volume
# Downstream should break the the chain by copying a wheel file to /etc/container/wheel
RUN /bin/ln -fsv /etc/container/wheel /etc/sudoers.d/container-wheel \
 && /bin/ln -fsv /mnt/volumes/container/wheel /etc/container/wheel
COPY wheel /etc/sudoers.d/wheel

# ╭――――――――――――――――――――╮
# │ TIMEZONES          │
# ╰――――――――――――――――――――╯
RUN /bin/cp -v /usr/share/zoneinfo/America/New_York /etc/localtime
RUN /bin/echo "America/New_York" > /etc/timezone



 
