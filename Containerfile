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
RUN /sbin/apk add --no-cache bind-tools curl git iputils nano nmap sudo shadow tzdata wget

# ╭――――――――――――――――――――╮
# │ TIMEZONES          │
# ╰――――――――――――――――――――╯
RUN /bin/cp -v /usr/share/zoneinfo/America/New_York /etc/localtime
RUN /bin/echo "America/New_York" > /etc/timezone

# ╭――――――――――――――――――――╮
# │ SUDO               │
# ╰――――――――――――――――――――╯
COPY wheel-crond.sudoers /etc/sudoers.d/wheel-alpine.sudoers

# ╭――――――――――――――――――――╮
# │ VERSIONING         │
# ╰――――――――――――――――――――╯
COPY version /bin/version
COPY 00-profile.sh /etc/profile.d/00-profile.sh

# ╭――――――――――――――――――――╮
# │ HEALTHCHECK        │
# ╰――――――――――――――――――――╯
COPY healthcheck /healthcheck
COPY hc-crond.sh /etc/healthcheck.d/hc-crond.sh
HEALTHCHECK --interval=10m --timeout=60s --start-period=5m --retries=10 CMD /healthcheck

# ╭――――――――――――――――――――╮
# │ ENTRYPOINT         │
# ╰――――――――――――――――――――╯
COPY entrypoint /entrypoint
COPY 00-ep-crond.sh /etc/entrypoint.d/00-ep-crond.sh
COPY 99-ep-exec.sh /etc/entrypoint.d/99-ep-exec.sh
ENTRYPOINT ["/entrypoint"]


