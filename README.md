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

All containers are ment to be run in `--detatch` mode.
```
docker run --detach --interactive --name alpine -p 2222:22 --rm --tty --volume ~/Workspace/alpine/bastion-container:/opt/bastion alpine:dev
```

To interact with the container
```
docker exec --interactive --tty alpine /bin/ash
```

### Deploy

```
docker tag alpine:dev docker.io/gautada/alpine:3.15.4
docker login --username=gautada docker.io
docker push docker.io/gautada/alpine:3.15.4
```

### Bastion Server

Bastion is the access to the container. To setup the bastion server, i.e. the ssh server

### Services
- Environments 
 - Profile
- Timezones
- Sudo
- Versioning
- Healthcheck
- Entrypoint
- Bastion
- Scheduler



```
docker exec --user root /usr/bin/ssh-keygen
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

#### Bastion

A [bastion](https://en.wikipedia.org/wiki/Bastion_host) is a networking host that is designed to withstand external attacks.  This container service uses the bastion concept as a point of entry for accessing the container and the services within. This service is implemented with [openssh](https://www.openssh.com). The primary mechanism for interacting with the container should remain using the `podman[docker] exec` function however the bastion service allows for external control when configured and pod-to-pod control when in a k8s cluster.

Basic setup is an sshd service on port `22`.  With `PermitRootLogin no` and `PasswordAuthentication no`, so no root logins allowed and no password based logins. To use provide a bastion folder via `volume` or an nfs volume for k8s.

When running local setup access via the `--port 22:2222` mapping and the ssh keys are mapped via `--volume ~/Workspace/alpine/bastion:/opt/bastion`. **Note:** `.gitignore` should be updated to not include the local bastion folder.

For security bastion cannot run out-of-the box, you must create the server keys and the authorized_keys file.  These keys are provided via the bastion folder/volume from the host so once created they should work from each reboot.  Running locally the **first run** of the container must be restarted after setup to get the bastion service started or use a generic alpine container to create the bastion folder/volume before first run.

```
docker exec --interactive --tty --user root alpine /usr/bin/bastion-setup
```

Gnerally, containers use only one **USER**.  Therefore, the generic `/opt/bastion/ssh` folder that contains the `authorized_keys` file should be owned and constrained for the single **USER**.
