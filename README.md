# Alpine

[Alpine Linux](https://alpinelinux.org) is an independent, non-commercial, general purpose Linux distribution designed for power users who appreciate security, simplicity and resource efficiency.

This container is the base image that uses Alpine Linux as the intial image for other containers as such it's primary purpose is to provide functionalityservices for other downstream containers.

## Features

- **Entrypoint**: A stacked collection of startup scripts that launch supporting services for the running container but still provide a mechanism for cli command execution.
- **Healthcheck**: A drop-in based system to stack all the needed checks for reporting container health including liveness and readiness.
- **Sudo**: Tightly controlled access to privilege escalation through a stacked collection
- **Backup**: A customizable container backup solution that defines a daily full backup and manages an hourly delta mechanism. 
- **Timezones**: This and all downstream containers are set to the same timezone
- **Users**: A standard user definition
- **Scheduler**: A time based esecution schedular for container self management
- **Environment Profile**: A stackable mechanism for CLI environment and porfile definitions
- **Version**: A stanrdway to get the version of the system being run.
- **Tools**: A defined set of tools that help with container debugging and manipulation.

## Details

### Entrypoint
This container provides the `/usr/bin/entrypoint` script and sets the `ENTRYPOINT` value in the **Containerfile**. The **entrypoint** script calla the subsequent scripts in the `/etc/entrypoint.d` drop-in folder.  These scripts start the container services and optionally executes the container processes.  If not overload by CLI parameter or entrypoint script, the default process is `crond`. Should considered using [s6](https://skarnet.org/software/s6/overview.html) or [supervisor.d](http://supervisord.org).

### Healthcheck
By default this image provides a method for checking the running health of a container. The script `/usr/sbin/container-healthcheck` runs all subscripts in the healthcheck drop-in folder
`/etc/container/healthcheck.d`. Healthchecks are generally considered to be cummulative. Downstream images should add more healthchecks using the `Containerfile` via `COPY hc-crond.sh /etc/container/healthcheck.d/hc-crond.sh`. Should consider [Probe Common Pitfalls](https://loft.sh/blog/kubernetes-liveness-probes-examples-and-common-pitfalls/). Down stream containers will need to include [--format=docker](https://github.com/gautada/alpine-container/issues/15) flag to parse the `HEALTHCHECK` tag.

### Profile 
The default profile for Alpine is the `ash` shell.  This is configured as default using `ENV ENV="/etc/profile"` in the `Containerfile`. Usually to customize just add scripts `/etc/profile.d` folder

### Sudo
To allow for super user access the container uses a wheel mechanism.  This requires the 
default user to be part of the `wheel` group via `/usr/sbin/usermod -aG wheel $USER`. To enable super user access to members of the `wheel` group, a wheel defintion file (wheel-[name]) must be provided that defines a sudo access line (i.e. `%wheel         ALL = (ALL) NOPASSWD: /usr/sbin/container-backup`). The wheel definition file should be loaded into the wheel drop-in folder in the `Containerfile` via `COPY wheel-backup /etc/container/wheel.d/wheel-backup`.

### Timezone
By default the timezone is set to US/New York a.k.a US/Eastern.  This provides consistency across containers.
```
RUN apk add --no-cache tzdata
RUN cp -v /usr/share/zoneinfo/America/New_York /etc/localtime
RUN echo "America/New_York" > /etc/timezone
```

### User
Each downstream image should co figure their own downstream default user in the `Containerfile`. Refer to the [gist](https://gist.github.com/gautada/bd71914073b8e3a89ad13f0320b33010) for reference on implementation.

### Version
This the operating system container defines two version [aliases](https://linuxhandbook.com/linux-alias-command/) (`osversion` and `cversion`)
- **Operating System(OS) Version** - `osversion` prints the release version of Alpine linux
- **Container Version** - `cversion` prints the container's version, this is mainly for downstream containers where the primary application's version is represented. For instance if the contain is to provide `podman` this would return `podman --version`. This allows for a standard mechanism to determine the running version of the container. **This should be overloaded in downstream systems**. For better compatability the script `/bin/version` is provided infront of the `cversion` alias.  This script can be called in an `exec` mode and should be called in lieu of a direct call to `cversion`.

### Tools
Look at the software installed in the container.

## Development

## Testing

## Deploy

## Architecture

### Context

![Context Diagram](https://puml.gautier.org/plantuml/svg/VLF1Rjim3BtxArIV4c3hBZqCmp0WItiejWL1i-rI584ciubGYJ8akNCsvDz7oRPa1_1EbiZto2Vo-KgYK4q5xEFwvjtwvhfkjFfKN4sZ-xL13wt_JvPB13kRrxL1m3d-xGcvbc8k2xKo9vtfXPTU0IjxKUnMyeFbchrbArMJ39Rqb4Mn1UiCxkzQloW931QvAj-myeS3-tZN1vv2PCLuuu_6oZzGiORIxDaQpVmHcCI00rykYy-cmOhRqwAa-szZNmBr7hiwR9DZoWWA3A0b-rkmJikYb7YXO-3Fw30OLUIArb358hzpKLhJK8b0VqWd06ikODfKe4Fkst2utssPC8WWl3GOuFc5B-zTW7nfViNNGxpHegWzPUAJniKb7Ymurmqa7V4WiMLz8CAjKOeKBgTiUkYh510ektoaHgo_qdwXhOq35mHtD1UhPCMrgG9hstq2cOv4hAA7fiGeVwmW9GDtFRxqllegiMbZn_DKkr1Sncd-DAhHPC3X7XLGD-ay-PTDqXVlVusvN6IM7eZdqLOxRoEFqzwiTl7JsOwjlEVYI3xQUMFv8N3FnGEeoR96azUy3YEDY55uCfb-2GDiREPHKQ_S1w4aoTuBi7v0Zt_1PCOPRCfdSqUdjZurpvbHwnXqZvlLzwS1r_iYxKcJOtAL5CuxYA44oF5-p5m8QXQ6y0y0)

### Container

{![Container Diagram(Link to image)}

### Components

{![Component Diagram(Link to image)}

## Administration

### Checklist

- [ X ] README conforms to the [gist](https://gist.github.com/gautada/ec549c846e8e50daf355d01b06eb0665)
- [ X ] .gitignore conforms to the [gist](https://gist.github.com/gautada/3a0a4a76d3c7e4539e71fc02c7f599ad)
- [ X ] Confirm the drone.yml file
- [ ] Volume folders are present (development-volume & backup-volume)
- [ ] docker-compose(.yml) works
- [ ] Manifest folder present (and origin to private repository is correct
- [ ] Issue List is linked to proper URI
- [ ] Signoff ({date and signature of last check})
- [ ] Confirm backup (maybe add to testing layer)
- [ ] Confirm healthcheck (maybe add to testing layer)
- [ ] Regenerate all architecture images


### Issues

The official to list is kept in a [GitHub Issue List]{(https://github.com/gautada/alpine/issues)}

## Notes

- Lookup if an [exitpoint](https://github.com/gautada/alpine-container/issues/19) can be worked in via a script in `/etc/profile`.
- Bastion service was an access mechanism that allowed for ssh access.  This was dropped in favor of `docker exec`.
- Log rotate is a way to limit the size of logs for long running container.  The containers should log everything to /dev/stdout.
- Scripts - Maybe use `set -xe` for debugging. See: [The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin). I think this might only be for bash











## Development

All container services should move to docker-compose for their build environments but for systems that need to **bootstrap** to get up and running the following is a template for manually getting things running.

### Build

```
docker build --build-arg ALPINE_VERSION=3.16.2 --file Containerfile --label revision="$(git rev-parse HEAD)" --label version="$(date +%Y.%m.%d)" --no-cache --tag alpine:build .
```

### Run

```
docker run -it --rm --name drone --publish 8080:8080 --volume=/Users/mada/Workspace/drone/development-volume:/opt/drone --volume=/Users/mada/Workspace/drone/backup-volume:/opt/drone drone:build /bin/ash
```

