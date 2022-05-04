ARG ALPINE_VERSION=3.15.4
FROM alpine:$ALPINE_VERSION

LABEL version="2022-04-29"
LABEL source="https://github.com/gautada/alpine-container.git"
LABEL maintainer="Adam Gautier <adam@gautier.org>"
LABEL description="This container is a basic Alpine Linux distribution for use as the basis for other containers."



ENV ENV="/etc/profile"

RUN apk add --no-cache tzdata
RUN cp -v /usr/share/zoneinfo/America/New_York /etc/localtime
RUN echo "America/New_York" > /etc/timezone

COPY version.sh /etc/profile.d/version.sh
COPY os-version.sh /etc/profile.d/os-version.sh

# ENTRYPOINT ["/usr/bin/tail", "-f", "/dev/null"]
CMD ["/usr/sbin/crond", "-f", "-l", "0"]
