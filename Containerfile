ARG IMAGE_NAME=alpine
ARG IMAGE_VERSION=3.22
FROM docker.io/library/alpine:${IMAGE_VERSION} as container

# ╭――――――――――――――――――――╮
# │ METADATA           │
# ╰――――――――――――――――――――╯
LABEL org.opencontainers.image.title="${IMAGE_NAME}"
LABEL org.opencontainers.image.description="An Alpine base container."
LABEL org.opencontainers.image.url="https://hub.docker.com/r/gautada/alpine"
LABEL org.opencontainers.image.source="https://github.com/gautada/alpine"
LABEL org.opencontainers.image.version="${CONTAINER_VERSION}"
LABEL org.opencontainers.image.license="Upstream"

# ╭――――――――――――――――――――╮
# │ VOLUMES            │
# ╰――――――――――――――――――――╯
RUN /bin/mkdir -p /mnt/volumes/configmaps /mnt/volumes/data \ 
    /mnt/volumes/backup /mnt/volumes/secrets  
                  
# ╭――――――――――――――――――――╮
# │ PACKAGES           │
# ╰――――――――――――――――――――╯
RUN /bin/sed -i 's|dl-cdn.alpinelinux.org/alpine/|mirror.math.princeton.edu/pub/alpinelinux/|g' /etc/apk/repositories \
 && /sbin/apk add --no-cache bind-tools ca-certificates curl iputils \
    nmap nmap-ncat git jq nano s6 shadow sudo tzdata zsh

# ╭―――――――――――――――――――╮
# │ CONFIG (ROOT)     │
# ╰―――――――――――――――――――╯
RUN /bin/mkdir -p /etc/container \
 && echo "America/New_York" > /etc/timezone \
 && /bin/ln -fsv "/usr/share/zoneinfo/$(cat /etc/timezone)" /etc/localtime
 
# ╭―――――――――――――――――――╮
# │ BACKUP            │
# ╰―――――――――――――――――――╯
COPY container-backup.sh /usr/bin/container-backup
RUN /bin/ln -fsv /usr/bin/container-backup /etc/periodic/hourly/container-backup
COPY backup.sh /etc/container/backup

# ╭――――――――――――――――――――╮
# │ ENTRYPOINT         │
# ╰――――――――――――――――――――╯
COPY container-entrypoint.sh /usr/bin/container-entrypoint
COPY entrypoint.sh /etc/container/entrypoint

# ╭――――――――――――――――――――╮
# │ INIT               │
# ╰――――――――――――――――――――╯
RUN mkdir -p /etc/services.d
COPY container-init /etc/services.d/container/run

# ╭――――――――――――――――――――╮
# │ PRIVILEGE          │
# ╰――――――――――――――――――――╯
COPY privileges /etc/container/privileges
RUN /bin/ln -fsv /etc/container/privileges /etc/sudoers.d/privileges \
 && /usr/sbin/groupadd --gid 99 privileged

# ╭――――――――――――――――――――╮
# │ VERSION            │
# ╰――――――――――――――――――――╯
COPY container-version.sh /usr/bin/container-version

# ╭――――――――――――――――――――╮
# │ HEALTH             │
# ╰――――――――――――――――――――╯
COPY container-health.sh /usr/bin/container-health
COPY health.txt /etc/container/health
RUN /bin/mkdir -p /etc/container/health.d \
 && /bin/ln -fsv /usr/bin/container-health /usr/bin/container-liveness \
 && /bin/ln -fsv /usr/bin/container-health /usr/bin/container-readiness \
 && /bin/ln -fsv /usr/bin/container-health /usr/bin/container-startup \
 && /bin/ln -fsv /usr/bin/container-health /usr/bin/container-test
COPY cron.health.sh /etc/container/health.d/cron.health
COPY os-test.sh /etc/container/health.d/os.test

# ╭――――――――――――――――――――╮
# │ USER               │
# ╰――――――――――――――――――――╯
ARG USER=alpine
ARG UID=1001
ARG GID=1001
SHELL ["/bin/ash", "-o", "pipefail", "-c"]
# ENTRYPOINT ["/usr/bin/container-entrypoint"]
RUN /usr/sbin/groupadd --gid $UID $USER \
 && /usr/sbin/useradd --create-home --gid $GID --shell /bin/zsh \
 --uid $UID $USER \
 && /usr/sbin/adduser $USER privileged \
#  && /usr/sbin/chpasswd << "$USER:$USER" \
 && echo "$USER:$USER" | /usr/sbin/chpasswd \
 && /bin/chown -R $USER:$USER /mnt/volumes/data \
 && /bin/chown -R $USER:$USER /mnt/volumes/backup \
 && /bin/chown -R $USER:$USER /mnt/volumes/configmaps \
 && /bin/chown -R $USER:$USER /mnt/volumes/secrets

# ╭――――――――――――――――――――╮
# │ CONTAINER          │
# ╰――――――――――――――――――――╯
FROM scratch
COPY --from=container / /
# ENTRYPOINT ["/usr/bin/container-entrypoint"]
# ENTRYPOINT ["zsh"]
ENTRYPOINT [ "/usr/bin/s6-svscan" , "/etc/services.d" ]
VOLUME /mnt/volumes/backup
VOLUME /mnt/volumes/configmaps
VOLUME /mnt/volumes/data
VOLUME /mnt/volumes/secrets
# VOLUME /mnt/volumes/secrets/namespace
# VOLUME /mnt/volumes/secrets/container
# EXPOSE 8080/tcp
# USER root
WORKDIR /
