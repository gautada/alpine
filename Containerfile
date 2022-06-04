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
USER root
WORKDIR /

# ╭――――――――――――――――――――╮
# │ PACKAGES           │
# ╰――――――――――――――――――――╯
RUN /sbin/apk add --no-cache bind-tools curl git iputils nano nmap openssh sudo shadow tzdata wget

# ╭――――――――――――――――――――╮
# │ TIMEZONES          │
# ╰――――――――――――――――――――╯
RUN /bin/cp -v /usr/share/zoneinfo/America/New_York /etc/localtime
RUN /bin/echo "America/New_York" > /etc/timezone

# ╭――――――――――――――――――――╮
# │ SUDO               │
# ╰――――――――――――――――――――╯
COPY wheel-alpine.sudoers /etc/sudoers.d/wheel-alpine.sudoers

# ╭――――――――――――――――――――╮
# │ VERSIONING         │
# ╰――――――――――――――――――――╯
COPY version /bin/version
COPY 00-profile.sh /etc/profile.d/00-profile.sh

# ╭――――――――――――――――――――╮
# │ HEALTHCHECK        │
# ╰――――――――――――――――――――╯
COPY healthcheck /healthcheck
COPY hc-*.sh /etc/healthcheck.d/
HEALTHCHECK --interval=10m --timeout=60s --start-period=5m --retries=10 CMD /healthcheck

# ╭――――――――――――――――――――╮
# │ ENTRYPOINT         │
# ╰――――――――――――――――――――╯
COPY entrypoint /entrypoint
COPY *-ep-*.sh /etc/entrypoint.d/
ENTRYPOINT ["/entrypoint"]

# ╭――――――――――――――――――――╮
# │ BASTION            │
# ╰――――――――――――――――――――╯
EXPOSE 22/tcp
VOLUME /opt/bastion
COPY bastion-setup /usr/bin/bastion-setup
COPY bastion.conf /etc/ssh/bastion.conf
RUN /bin/cat /etc/ssh/bastion.conf >> /etc/ssh/sshd_config

# ╭――――――――――――――――――――╮
# │ USER               │
# ╰――――――――――――――――――――╯
ARG USER=bastion
RUN /bin/mkdir -p /opt/$USER \
 && /usr/sbin/addgroup $USER \
 && /usr/sbin/adduser -D -s /bin/ash -G $USER $USER \
 && /usr/sbin/usermod -aG wheel $USER \
 && /bin/echo "$USER:$USER" | chpasswd \
 && /bin/chown $USER:$USER -R /opt/$USER

