# Alpine

A very simple container that uses [Alpine Linux]().  This container is designed to be the default base for most containers in this library.

## Build

```
docker build --build-arg ALPINE_VERSION=3.15.3 --file Containerfile --no-cache --tag alpine:dev .
``` 

## Run

This container is designed to run in detatched mode.  As such the main **CMD** launched `crond` therefore to run the container execute:

```
docker run --detach --name alpine --rm alpine:dev  
```

To interact with the container just execute:

```
docker exec --interactive --tty alpine /bin/ash 
```

To kill the container just execute:

```
docker stop alpine
```

## Setup and Configuration

This is the core/default starting point for all of my containers.  As such there are several configurations that are used to get everything just the way I like it.

### Profile

Load the system profile when you exec the `ash` shell inside docker

```
ENV ENV="/etc/profile"
```

### Timezone

Set the timezone to New York a.k.a US/Eastern

```
RUN apk add --no-cache tzdata
RUN cp -v /usr/share/zoneinfo/America/New_York /etc/localtime
RUN echo "America/New_York" > /etc/timezone
```

### Aliases

In general there needs to be a consistent set of aliases across all containers.  For example an `aliases.sh` file is used to make the process easier and is placed in the `/etc/profile.d` folder.

#### Version

This profile script `version.sh` by default provides the specific Alpine Linux version number that is being used. This also creates and os-version.sh which is the exact same script but should not be overloaded down stream.

**Alpine Linux Version**

```
awk -F= '$1=="VERSION_ID" { print $2 ;}' /etc/os-release
```

https://linuxhandbook.com/linux-alias-command/
