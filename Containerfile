ARG ALPINE_VERSION=3.21.3
# ╭―――――――――――――-――――――――――――――――――――――――――――-――――――――――――――――――――――――――――――――╮
# │                                                                           │
# │ CONTAINER BUILD                                                           │
# │                                                                           │
# ╰―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――╯
FROM alpine:$ALPINE_VERSION as container

# ╭――――――――――――――――――――╮
# │ METADATA           │
# ╰――――――――――――――――――――╯
LABEL org.opencontainers.image.title="alpine"
LABEL org.opencontainers.image.description="An Alpine base container."
LABEL org.opencontainers.image.url="https://hub.docker.com/r/gautada/alpine"
LABEL org.opencontainers.image.source="https://github.com/gautada/alpine"
LABEL org.opencontainers.image.version="${CONTAINER_VERSION}"
LABEL org.opencontainers.image.license="Upstream"

# ╭――――――――――――――――――――╮
# │ VOLUMES            │
# ╰――――――――――――――――――――╯
RUN /bin/mkdir -p /mnt/volumes/configmaps \
                  /mnt/volumes/container \ 
                  /mnt/volumes/backup \
                  /mnt/volumes/secrets  
                  
# ╭――――――――――――――――――――╮
# │ PACKAGES           │
# ╰――――――――――――――――――――╯
RUN /bin/sed -i 's|dl-cdn.alpinelinux.org/alpine/|mirror.math.princeton.edu/pub/alpinelinux/|g' /etc/apk/repositories
RUN /sbin/apk add --no-cache zsh \
                             bind-tools \
                             ca-certificates \
                             curl \
                             iputils \
                             nmap \
                             nmap-ncat \
                             git \
                             jq \
                             nano \
                             shadow \
                             sudo \
                             tzdata 

# ╭―――――――――――――――――――╮
# │ CONFIG (ROOT)     │
# ╰―――――――――――――――――――╯
# --- [ GENERAL - OS LEVEL CONFIG ] ---
RUN /bin/mkdir -p /etc/container \
 && echo "America/New_York" > /etc/timezone \
 && /bin/ln -fsv /usr/share/zoneinfo/$(cat /etc/timezone) /etc/localtime
 
# ╭―――――――――――――――――――╮
# │ BACKUP            │
# ╰―――――――――――――――――――╯
COPY container-backup /usr/bin/container-backup
RUN /bin/ln -fsv /usr/bin/container-backup \
                 /etc/periodic/hourly/container-backup
COPY backup /etc/container/backup

# ╭――――――――――――――――――――╮
# │ ENTRYPOINT         │
# ╰――――――――――――――――――――╯
COPY container-entrypoint /usr/bin/container-entrypoint
COPY entrypoint /etc/container/entrypoint

# ╭――――――――――――――――――――╮
# │ PRIVILEGE          │
# ╰――――――――――――――――――――╯
COPY privileges /etc/container/privileges
RUN /bin/ln -fsv /etc/container/privileges \
                 /etc/sudoers.d/privileges \
 && /usr/sbin/groupadd --gid 99 privileged
 
# ╭――――――――――――――――――――╮
# │ VERSION            │
# ╰――――――――――――――――――――╯
# COPY base-version /usr/bin/container-version

# ╭―
# │ HEALTH
# ╰―――――――――――――――――――― 
COPY container-health /usr/bin/container-health
COPY health /etc/container/health
RUN /bin/mkdir -p /etc/container/health.d \
 && /bin/ln -fsv /usr/bin/container-health /usr/bin/container-liveness \
 && /bin/ln -fsv /usr/bin/container-health /usr/bin/container-readiness \
 && /bin/ln -fsv /usr/bin/container-health /usr/bin/container-startup \
 && /bin/ln -fsv /usr/bin/container-health /usr/bin/container-test
COPY cron.health /etc/container/health.d/cron.health
# *** TESTING ***
COPY os.test /etc/container/health.d/os.test

# ╭―
# │ USER
# ╰――――――――――――――――――――
ARG USER=alpine
ARG UID=1001
ARG GID=1001  
RUN /usr/sbin/groupadd --gid $UID $USER \
 && /usr/sbin/useradd --create-home \
                      --gid $GID \
                      --shell /bin/zsh \
                      --uid $UID $USER \
 && /usr/sbin/adduser $USER privileged \
 && /bin/echo "$USER:$USER" | /usr/sbin/chpasswd \
 && /bin/chown -R $USER:$USER /mnt/volumes/container \
 && /bin/chown -R $USER:$USER /mnt/volumes/backup \
 && /bin/chown -R $USER:$USER /mnt/volumes/configmaps \
 && /bin/chown -R $USER:$USER /mnt/volumes/secrets

# ╭―
# │ FINAL CONTAINER
# ╰――――――――――――――――――――
FROM scratch
COPY --from=container / /
ENTRYPOINT ["/usr/bin/container-entrypoint"]
VOLUME /mnt/volumes/backup
VOLUME /mnt/volumes/configmaps
VOLUME /mnt/volumes/container
VOLUME /mnt/volumes/secrets
# VOLUME /mnt/volumes/secrets/namespace
# VOLUME /mnt/volumes/secrets/container
# EXPOSE 8080/tcp
USER root
WORKDIR /
