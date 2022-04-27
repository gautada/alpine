ARG ALPINE_VERSION=3.15.4
FROM alpine:$ALPINE_VERSION

RUN apk add --no-cache tzdata

RUN cp -v /usr/share/zoneinfo/America/New_York /etc/localtime
RUN echo "America/New_York" > /etc/timezone

ENTRYPOINT ["tail", "--follow", "/dev/null"]
