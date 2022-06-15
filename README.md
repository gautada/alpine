# Alpine

[Alpine Linux](https://alpinelinux.org) is an independent, non-commercial, general purpose Linux distribution designed for power users who appreciate security, simplicity and resource efficiency.

A very simple container that uses [Alpine Linux](https://alpinelinux.org).  This container is the base image for other containers as such it's primary purpose is to provide functionality and services for other downstream containers.

## Container Services

- Entrypoint: A stacked collection of startup scripts that launch supporting services for the running container but still provide a mechanism for cli command execution.
- Exitpoint: Similar to entry pointbut on container application exit.
- Healthcheck: A drop-in based system to stack all the needed checks for reporting container health including liveness and readiness.
- Sudo: Tightly controlled access to privilege escalation through a stacked collection
- Backup: A customizable container backup solution that defines a daily full backup and manages an hourly delta mechanism. 
- Timezones: This and all downstream containers are set to the same timezone
- Schedular: A time based esecution schedular for container self management
- Environment Profile: A stackable mechanism for CLI environment and porfile definitions
- Tools: A defined set of tools that help with container debugging and manipulation.

## Container

### Versions

- April 30, 2022 [alpine](https://alpinelinux.org/releases/) - Active version is [3.15 .4](https://git.alpinelinux.org/aports/log/?h=v3.15.4)
- May 31, 2022 [alpine](https://alpinelinux.org/releases/) - Active version is [3.16 .0](https://git.alpinelinux.org/aports/log/?h=v3.16.0)

### Configuration

#### Build Arguments

Image Version and Application Version

#### Build

```
db
``` 

#### Run
```
dr
```

All containers are ment to be run in `--detatch` mode. To interact

```
de
```

#### Deploy

```
dp
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

#### Entrypoint

This container provides the `/entrypoint` script and sets the `ENTRYPOINT` value in the **Containerfile**. The `/entrypoint` script call the subsequent scripts in the `/etc/entrypoint.d` folder.  These scripts start the container services and optionally executes the container processes.  If not overload by CLI parameter or entrypoint script, the default process is `crond`.

#### Timezone

Set the timezone to US/New York a.k.a US/Eastern.  This provides consistency across containers.

```
RUN apk add --no-cache tzdata
RUN cp -v /usr/share/zoneinfo/America/New_York /etc/localtime
RUN echo "America/New_York" > /etc/timezone
```

## Notes

### User configuration (Containerfile)

```
ARG USER=postgres
VOLUME /opt/$USER
RUN /bin/mkdir -p /opt/$USER \
 && /usr/sbin/addgroup $USER \
 && /usr/sbin/adduser -D -s /bin/ash -G $USER $USER \
 && /usr/sbin/usermod -aG wheel $USER \
 && /bin/echo "$USER:$USER" | chpasswd \
 && /bin/chown $USER:$USER -R /opt/$USER /etc/backup /var/backup /tmp/backup /opt/backup
USER $USER
WORKDIR /home/$USER
```
