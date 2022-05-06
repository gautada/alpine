# Alpine

[Alpine Linux](https://alpinelinux.org) is an independent, non-commercial, general purpose Linux distribution designed for power users who appreciate security, simplicity and resource efficiency.

A very simple container that uses [Alpine Linux](https://alpinelinux.org).  This container is designed to be the default base for most containers in this library.

## Container

### Versions

- - April 30, 2022 [alpine](https://alpinelinux.org/releases/) - Active version is [3.15 .4](https://git.alpinelinux.org/aports/log/?h=v3.15.4)

### Build

```
docker build --build-arg ALPINE_VERSION=3.15.4 --file Containerfile --label revision="$(git rev-parse HEAD)" --label version="$(date +%Y.%m.%d)" --no-cache --tag alpine:dev .
``` 

### Run

This container is designed to run in detatched mode.  As such the main **CMD** launched `crond` therefore to run the container execute:

```
docker run --detach --name alpine --rm alpine:dev  
docker run --interactive --name alpine --rm --tty --volume ~/Workspace/alpine/bastion:/opt/bastion alpine:dev /bin/ash
```

To interact with the container just execute:

```
docker exec --interactive --tty alpine /bin/ash 
```

To kill the container just execute:

```
docker stop alpine
```

### Container Configuration

These are the container configurations usually made in the `Containerfile` and may be over-ridden in downstream containers.
 
#### Profile
 
Load the system profile when you exec the `ash` shell inside docker. This provides a convenienc for the 
profile to loaded automatically when the container is `run` or `exec` with `/bin/ash`. The
profile will provide consistency and a customization point for downtstream
containers. Usually to customize just add scripts `/etc/profile.d` folder

Enable profile to be executed automatically
```
ENV ENV="/etc/profile"
```

This the operating system container defines two version [aliases](https://linuxhandbook.com/linux-alias-command/) (`osversion` and `cversion`)
- **Operating System(OS) Version** - `osversion` prints the release version of Alpine linux
- **Container Version** - `cversion` prints the container's version, this is mainly for downstream containers where the primary application's version is represented. For instance if the contain is to provide `podman` this would return `podman --version`. This allows for a standard mechanism to determine the running version of the container. **This should be overloaded in downstream systems**. For better compatability the script `/bin/version` is provided infront of the `cversion` alias.  This script can be called in an `exec` mode and should be called in lieu of a direct call to `cversion`.

#### Timezone

Set the timezone to US/New York a.k.a US/Eastern.  This provides consistency across containers.

```
RUN apk add --no-cache tzdata
RUN cp -v /usr/share/zoneinfo/America/New_York /etc/localtime
RUN echo "America/New_York" > /etc/timezone
```


