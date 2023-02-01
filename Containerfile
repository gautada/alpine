ARG ALPINE_VERSION=3.16.2

# ╭――――――――――――――――---------------------------------------------------------――╮
# │                                                                           │
# │ STAGE 1: alpine-container                                                 │
# │                                                                           │
# ╰―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――╯
FROM alpine:$ALPINE_VERSION
RUN /bin/mkdir -p /etc/container && /sbin/apk list > /etc/container/original.apk

# ╭――――――――――――――――――――╮
# │ METADATA           │
# ╰――――――――――――――――――――╯
LABEL version="2022-11-17"
LABEL source="https://github.com/gautada/alpine-container.git"
LABEL maintainer="Adam Gautier <adam@gautier.org>"
LABEL description="Alpine Linux base container."

# ╭――――――――――――――――――――╮
# │ VOLUMES            │
# ╰――――――――――――――――――――╯
RUN /bin/mkdir -p /mnt/volumes/configmaps /mnt/volumes/container /mnt/volumes/backup

# ╭―――――――――――――――――――╮
# │ BACKUP            │
# ╰――――――――――――――――――――╯
RUN /sbin/apk add --no-cache duplicity
COPY container-backup /usr/bin/container-backup
COPY backup /etc/container/backup
RUN /bin/mkdir -p /var/backup /tmp/backup \
 && ln -fsv /usr/bin/container-backup /etc/periodic/hourly/container-backup \
 && ln -fsv /mnt/volumes/container/signer.key /mnt/volumes/configmaps/signer.key \
 && ln -fsv /mnt/volumes/configmaps/signer.key /etc/container/signer.key \
 && ln -fsv /mnt/volumes/container/encrypter.key /mnt/volumes/configmaps/encrypter.key \
 && ln -fsv /mnt/volumes/configmaps/encrypter.key /etc/container/encrypter.key \
 && ln -fsv /mnt/volumes/container/validator.key /mnt/volumes/configmaps/validator.key \
 && ln -fsv /mnt/volumes/configmaps/validator.key /etc/container/validator.key \
 && ln -fsv /mnt/volumes/container/decrypter.key /mnt/volumes/configmaps/decrypter.key \
 && ln -fsv /mnt/volumes/configmaps/decrypter.key /etc/container/decrypter.key 

# ╭――――――――――――――――――――╮
# │ DEVELOPMENT        │
# ╰――――――――――――――――――――╯
# Uncommend to test the .dockerignore build context [Reference](https://www.geeksforgeeks.org/how-to-use-a-dockerignore-file/)
COPY . /.context

# ╭――――――――――――――――――――╮
# │ ENTRYPOINT         │
# ╰――――――――――――――――――――╯
RUN /bin/ln -fsv /mnt/volumes/container/entrypoint /etc/container/entrypoint
COPY container-entrypoint /usr/bin/container-entrypoint
ENTRYPOINT ["/usr/bin/container-entrypoint"]

# ╭――――――――――――――――――――╮
# │ ENVIRONMENT        │
# ╰――――――――――――――――――――
ENV ENV="/etc/profile"
COPY profile /etc/container/profile
RUN /bin/ln -fsv /etc/container/profile /etc/profile.d/container-profile.sh


# ╭――――――――――――――――――――╮
# │ PACKAGES           │
# ╰――――――――――――――――――――╯
RUN /sbin/apk add --no-cache bind-tools curl iputils nano nmap nmap-ncat shadow sudo tzdata wget py3-requests
RUN /sbin/apk list > /etc/container/alpine.apk

# ╭――――――――――――――――――――╮
# │ PRIVILEGE          │
# ╰――――――――――――――――――――╯
COPY _wheel /etc/container/.wheel
RUN /bin/ln -fsv /etc/container/.wheel /etc/sudoers.d/_wheel \
 && /bin/ln -fsv /etc/container/wheel /etc/sudoers.d/wheel

# ╭――――――――――――――――――╮
# │STATUS             │
# ╰――――――――――――――――――╯
# Conforms to the status component design.
COPY container-health-check /usr/bin/container-health-check
COPY container-status-check /usr/bin/container-status-check
COPY alpine-latest-stable-version /usr/bin/alpine-latest-stable-version
RUN /bin/ln -fsv /usr/bin/container-health-check /usr/bin/container-liveness-check \
 && /bin/ln -fsv /usr/bin/container-health-check /usr/bin/container-readiness-check \
 && /bin/ln -fsv /usr/bin/container-health-check /usr/bin/container-startup-check
COPY alpine-latest-stable-version /usr/bin/alpine-latest-stable-version
# COPY alsv-updater /usr/bin/alsv-updater
# RUN /bin/ln -fsv /usr/bin/alsv-updater /etc/periodic/monthly/alsv-updater
HEALTHCHECK --interval=10m --timeout=60s --start-period=5m --retries=10 CMD /usr/bin/container-health-check

# ╭――――――――――――――――――――╮
# │ TIMEZONES          │
# ╰――――――――――――――――――――╯
RUN /bin/cp -v /usr/share/zoneinfo/America/New_York /etc/localtime
RUN /bin/echo "America/New_York" > /etc/timezone

# ╭――――――――――――――――――――╮
# │VERSION            │
# ╰――――――――――――――――――――╯
COPY version /usr/bin/container-version



















# RUN mkdir /etc/container/configmap.d /etc/container/keys.d
# USER root
# WORKDIR /
