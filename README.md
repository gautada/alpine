# Alpine

[Alpine Linux](https://alpinelinux.org) is an independent, non-commercial, general purpose Linux distribution designed for power users who appreciate security, simplicity and resource efficiency.

This container is the base image that uses Alpine Linux as the intial image for other containers as such it's primary purpose is to provide functionalityservices for other downstream containers.

## Features

- **Backup**: A customizable container backup solution that defines a daily full backup and manages an hourly delta mechanism. 
- **Entrypoint**: A stacked collection of startup scripts that launch supporting services for the running container but still provide a mechanism for cli command execution.
- **Healthcheck**: A drop-in based system to stack all the needed checks for reporting container health including liveness and readiness.
- **Sudo**: Tightly controlled access to privilege escalation through a stacked collection
- **Timezones**: This and all downstream containers are set to the same timezone
- **Users**: A standard user definition
- **Scheduler**: A time based esecution schedular for container self management
- **Environment Profile**: A stackable mechanism for CLI environment and porfile definitions
- **Version**: A stanrdway to get the version of the system being run.
- **Tools**: A defined set of tools that help with container debugging and manipulation.

## Details

### Backup
![Container Diagram - Backup](https://www.plantuml.com/plantuml/png/hLLXRzis4FtkNy4Pm-O0JfJ4JheMGzF6zhfYMLl42V9X60oAEbk4AL8WAI-Uu_--esI9aYCNGTSWiCZZlNjtxuxIEsEfjbaYEZzmoKGM0VbrD0n6mvCKZM_thREHaXOUxLTEAPUW3vudgP8W3-77QqaJpWwTGYhKEl7mpizaCrqR2ydJH5hGgUO6PjjhbSc8wdMF2avDdmWQWkYJpPLTfx3jaojB5sZ-KN2vFC8ONq0R9JUpoQFTxc6k8Z1CuzDWR0lFi8ZUAOAhu-8FLqLItn8HmPM8FgGBwksRSVWqeYo6frO22ooMBqgzQaUJoTl_7zELPxe5GIrNqiGyzMGbt-QQRz5Zyr56yDZZxlUfDzSgmMPPzIrydvG5KnBXK-AUTEzYRWZ-qtpV9TGGUOQd3eT4X0q924ZUe9My9NcnURI_HaFoHL1fx_-y-RiNMvkQDq6GEWlEuR6naU3XoOBRE0jFkC9PFIxTWoE7_y2D9NUG8CI2Zx10SmbZAWaMDBCqei5PI2z_kQ23rnUlNiq7z9BHrwTmFWY7v_Epqy4PpMDE7Yd60rDBADDweMcISBau4NmE0JC16nwNYHvzFMR7SYjGfMhEo9XJ5uySaslAbbdQxNptuUXKuNfTffMCkdtCe5p08p2K91JWTbFaYZ81kekuwf9tmJ9t6koUSoKYvq8s7UATOfLfiIxzWXGqLn5dWRVNSRv8B0qpcx5IarbOAD6lwtHTsR1KdbgtAcp40RKIf3Z0nCcsdXOUp_cYIgkYEPmGrYkPNgUsS9gK6_8756Lm0RK3hYH9ir1mHfReSDGCPVXYHpPrgsOGRyNEhQY5jWY57BDv9fdZgbN-cpTvMMgY5KXI8NDfjlN6XZm71vdHWLitDQbdyTtQquWQPIdgncqkoTXl6dFfOtaZ2gRSnS5usqwz8flaQGJu37ochKMDGsoFoZGh6b6jN6kCMzpBSX0Ymjmr96fEybDYrKxTF05Flw8wfyVdI-YfPZ5VGQDwyjuR7Mk-k4FodJE9k0PcbSP9QNRJ4mQ9jC5AYIm1yv8yBDKBi3bHkV8oJ2eHg8n8Fj1HDLlEgSZZ5aJnTJdj4_-YQRdN_ZNZa0WxSFlRR3TSBX5KSPsr-xLTcezofPPWwkZpTay_5DSP5r43CcWdR4xoY0hHG0ttFJp5BT0cmyMURtr8yez1m_jotzktya5pMtJGZ_5Fk_wLmZUW_brrRy2qkFX8-rvjcfHtSII0IkU8dwBAoxtqVMZV_sSl0dG4BQaWbGknCRN4h2MBjPByNp2au3H4pUU6Mq0kVoleFxa6xn-cP2HK5f4fw1LdXJAcM3-x4aL-OSQMXPRJWVj4Lrj_yBbW916rb6X8bU7LrKHX3jRespJrXI3gCCQpxcCwqzy_Fynk9XycdyQzeyuxa56MYFy0)
![Component Diagram - Backup](https://www.plantuml.com/plantuml/svg/jLPjRzis4FxkNy4P0sO3IPGNfrsBeUbYUrsnh0toiduO1eEcpZOHYXH8oh3WvB-FegAJc2dgqBX54P5tzppFyOulVcyirJPBHEy7Bfd8OY2_Z4VHU7IGEkExfzRPM4aB6zlXfLo2VjQVf4g2V0u_oILDE7lE2wbGULB3Up-HxNLkB2JtKvUMJZKtC7iuLvcCgSu7L71gzeYWSn1xP7jcynGUziYPfKjd_b5mUJTq79UWZPBRsNHZ7vvWpc8mJBklSTmM_eDrwCUAkD5--S-DogI-XT61iOX8MPAYVJkPtuyfMy5zgu05jfB_AtLiHwXKsr-cT5OhNO6WbYjfLZn5CTJRdlC75x7zA6FO37Znztwmq2fnpRBgM_G-AGl6VIi5wUQaVxFYXhZ_rC_xX1eYZvotm3aXmaO412HldPMy8twndktlyOXS2YhjxPyN_mnMrgRcRHIbXILBnBwniU3pWoMtgsn-m9NRg_jLU3Giy1-uiUG64WUnK3CidRc2CPL4IvfP6jFeQ4vV_NnAJzwSldwzEA6l67rp2CSdyz7nukZmv8Xwpkc6EZumZOGohPUQ9WcNomF15n0n4x7HVfNei9kpPxaLhagupyY4quAFx9DpokwojD_R-UP0ja4_pbB16RTvVu_q9yq9R82voim55BCo5r8RIQfLaMS_e6DQoRY87rU3aERQPHvd0hI3zV3AwC-vBBnHPdJqE5ue4HTXPDiZJO6gJhDvMPszPktEqUQMprFRoBm0QYL8wN3o3yq4LYhJ8lSvW6LH2fghcBC8xUtvk1wud6RVAIcRU5JalX4IToPIHiqMcMJ5mMye_OQcbZHA647OC2YvSJLWPVTmjE02J36uTJ5Cvwc5cB1YNnAr8DvBh7eazkkgbxMcsY_BVJkNvSMfPYk-Xc1tabzhOw7f1pTE-Z6On5m3iqhdJoiAbc6FiMaTwjNQVCoqcf0_8A-Aq72uof4qcxiSoPqB28iOGuDf0grCwF1Ccg-fXHOgmvUFML_xKK22rWw2DHKyfbPvZh-gIK0JE9vTrCwscsjIUCONV9dGyXpXPDXev2o8YH9fexKIMG8cGe_vocbXoMnN_KN2dRKP6L_ORUHvKTE3GrHVTosrHqztwNTT-PqNVaTrts7PyQeCIlxr6zHIlGJhhqWSuVKznSkRofZuDSTuFdsGp-8AHFapyT1Xy8rlUVVmXVT8X1qvHqjmsmNoKQxLNOW-BhHQGkk7wJpZ8Wum9-sAuU-TCHKYG8s2Y43Y2cYeSFeqjYxq5yrjjOJMdopLqpuMG2K6jjMp5Nt1vPq3ULIOGt2iRWqc4KRvFdU7uBkBCRrIhwrdRSsvr6gJOvBDl8AB5vTJf9KdmWsnRa_2M3SAwm6X5CwxfK8OJZkbi8x1HTqXqW3uSJTzS7U4LtYNI0Z3QQTKy9pEWjddDMZYTtGnIrLiKc0EUFtxvo-pY-c7wQV9ODXx3pBE4l4l)

### Entrypoint
This container provides the `/usr/bin/entrypoint` script and sets the `ENTRYPOINT` value in the **Containerfile**. The **entrypoint** script calla the subsequent scripts in the `/etc/entrypoint.d` drop-in folder.  These scripts start the container services and optionally executes the container processes.  If not overload by CLI parameter or entrypoint script, the default process is `crond`. Should considered using [s6](https://skarnet.org/software/s6/overview.html) or [supervisor.d](http://supervisord.org).

![Container 
Diagram](https://www.plantuml.com/plantuml/svg/dL9nJzi-4Fq_dyA_w2UjaL82jC2Onife8pQf54GPqpHDaPDS6skE7SKNYQZqk-y2DAQT2XFv9_QxzzuzstTga9TOvTBvJwX4LYcmZyD-CEpl50H-saIZeLO8T_X2bGi5vTPwNcW5Qfj-L2kUYsHR5GgfwzpAdNViAG-jkeyVhHRJsY3azo6Log8K1gBbcQvKoikwmwNWncUIno1zjXXWNS3IPmFaSuB_bqBzziZZ2agZrI8Axt2veHcaO9AI_eQy4VxMFhP_YvR4xHMsHwBlERxfY91awlLKPD7U_hgrnHUZ-7x8ampk7xB_Quk1RN4DagFGocIYi5tQXpaJIs9qPgNEVORQVqE7dyC-kv9SuRUByQzEXbYO3q5GD0ZDHDTWAaMyCnUOLV6Eq3GttHKzy1hzkJ38RY0d2O9rc1EyaYKw3-QyGfxoO2_cX-yFUE_uuEXerkE72J_UXVrUtD-VxUtszZWz6WgKmDpsXTX8y7d9SzPbeSAoBhHGw3gEqmwXcwouhlzCw7fiuTZdU4QBm1hvpEBTTHpk8A7OiGJNMpFQeAtjPfLA7jwCDCxJy5BhKgkKoayBprPiaysMbcCoaB8fVvO5vMJJPa-4fUFG06m_sFfkh7bAgLwKsA1ZJWV9LlIj5sEPJJnJg-Ha-cDw4rv4uUJsw_Nbv2ASt9oCmjjmV7dLh5y9OCzgRLyrd7wv_1wDm_DmCkfupYceb8Rt3m00)
### Healthcheck

Containers run within a container enviroment which may provide a health status/probe to determine the 
current running state of the container.  This root container provides the default mechanism to support such 
a probe as defined in [Reference Architecture - Kubernetes Health 
Probe](https://github.com/gautada/celsus/blob/main/references/K8sHealthProbes.md). Downstream containers 
must provide a custom `/usr/bin/container-status-check` which overrides the default script provided here.  
To provide customized 

- To override the specific probe scripts (liveness, readiness, startup) just use the `COPY` command to 
overwrite the symlinks. 
- Should consider [Probe Common Pitfalls](https://loft.sh/blog/kubernetes-liveness-probes-examples-and-common-pitfalls/).
- Downstream build scripts will need to include [--format=docker](https://github.com/gautada/alpine-container/issues/15) flag to parse the `HEALTHCHECK` tag.

### Profile 
The default profile for Alpine is the `ash` shell.  This is configured as default using `ENV ENV="/etc/profile"` in the `Containerfile`. Usually to customize just add scripts `/etc/profile.d` folder

### Privilege

This feature allows for sudo access to specifc applications.  This mechanism uses the a `wheel` group mechanism which requires the default user to be part of the `wheel` group via `/usr/sbin/usermod -aG wheel $USER`. To enable super user access to members of the `wheel` group, a wheel defintion file (wheel-[name]) must be provided that defines a sudo access line (i.e. `%wheel         ALL = (ALL) NOPASSWD: /usr/sbin/container-backup`). The wheel definition file should be loaded into the wheel drop-in folder in the `Containerfile` via `COPY wheel-backup /etc/container/wheel.d/wheel-backup`.

**Note: ** The `/etc/sudoers.d/` drop-in folder mechanism does not support any files witj a `.` in the name.  So no `filename.ext` filenames.

![Container Diagram - Privilege](https://www.plantuml.com/plantuml/svg/fLH_Rzis4FrVdu8p1im2RAjft7OjXgQeRNG3qYveMkoFOL1fwIGJeqY1FpORZh_xZf9rIZmboB8W2Cd7U--TZdTvPnqtpbSo-aweJFeSs4-BURAOpse4tvwYwK8h1rltm2qN2iozzrMj5QZx-CkTufN8xhk5MkfTrTEZ7zZ-UcSTL3ShJClKHbX83--rLpatkp6NWji9atmDSiBs5svNms72BXml4VvU2lLdZ1fNOAnM-tIrTOSJpaKEDZEuMjHsy2ykieyLmTsq_S5TczHJ595CHMmbIPJm_N9zi-3P1cu63Hna6_MerEavJfm8_tzE5xtJPv3S2QtiHjHaHdxxz-A04VjVL0xRiGX_RyQ5qHK-bjDFyVka7TZE25U5PpRwiX6MuIzlpYF6BLDdU1juQCIoEGC9rHj4sLlMV6oZzljYpguaL-xhnyi_nXldQlicIUg0O1zEhSkbMCzAuJP-FHCQUtNQXITnu7yGrh4lK275GQzG8jpHCbqb9VUEvpmvM_ENFxxWvwzVl7fLdFEN6N_z39wVh-VFYxDdvsUyqLnjEUg1lPMGDwOqlAg4AcTI591aDidcqoxH-67Do0adiKhKPsmfUD1ZKtPbn5z2GWcZAABn6lsz0P1fQRIlHnFM7iEcHMAsZuwpDHvv2oPSVJskIoYubuvbPDP4nD7XjW6uB0GdnxNGCWVJ2bEFZaVMvnfjCEBs5fKBKORTHpHWtyBLDzQYtZJTo0eX0JrPxvWRNGlLcIP7lLb-Qj_xusHW3YbzI4fb86ZQGl40ZO8f10l0xbIWbwQq2BatBTH-H4PKfk4dQO9OyvgixZhWRWb7yLrJqXqmMFnNuGDsmyaxemwji8NCExwM44whvWGMPQgAgzo6yRQ-he-zDM4uPxQtGuEXOeMMe6G9E2qKNbZK0qOyb8i-W-mwdRAalCAUp7CAFpKc_YBu-T8WCnu8fHe_CfQ0T9ZLfaDPTqLyy0k8SMlwIBZqA3mGr4_OfUOvHJmuG3rqlQl2VsjYqSL0H1HT__phR-dbwiFgqt8SH-z0vRwI_m00)

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

### Scheduler


### Tools
Look at the software installed in the container.

## Development

## Testing

## Deploy

## Architecture

### Context

![Context Diagram](https://www.plantuml.com/plantuml/png/VLF1Rjim3BtxArIV4c3hBZqCmp0WItiejWL1i-rI584ciubGYJ8akNCsvDz7oRPa1_1EbiZto2Vo-KgYK4q5xEFwvjtwvhfkjFfKN4sZ-xL13wt_JvPB13kRrxL1m3d-xGcvbc8k2xKo9vtfXPTU0IjxKUnMyeFbchrbArMJ39Rqb4Mn1UiCxkzQloW931QvAj-myeS3-tZN1vv2PCLuuu_6oZzGiORIxDaQpVmHcCI00rykYy-cmOhRqwAa-szZNmBr7hiwR9DZoWWA3A0b-rkmJikYb7YXO-3Fw30OLUIArb358hzpKLhJK8b0VqWd06ikODfKe4Fkst2utssPC8WWl3GOuFc5B-zTW7nfViNNGxpHegWzPUAJniKb7Ymurmqa7V4WiMLz8CAjKOeKBgTiUkYh510ektoaHgo_qdwXhOq35mHtD1UhPCMrgG9hstq2cOv4hAA7fiGeVwmW9GDtFRxqllegiMbZn_DKkr1Sncd-DAhHPC3X7XLGD-ay-PTDqXVlVusvN6IM7eZdqLOxRoEFqzwiTl7JsOwjlEVYI3xQUMFv8N3FnGEeoR96azUy3YEDY55uCfb-2GDiREPHKQ_S1w4aoTuBi7v0Zt_1PCOPRCfdSqUdjZurpvbHwnXqZvlLzwS1r_iYxKcJOtAL5CuxYA44oF5-p5m8QXQ6y0y0)

### Container

![Container Diagram](https://plantuml.com/plantuml/svg/dLDBRzim3BxxLwZ6WCI07vUSXdL1cnZheTk2PUqEHH4eDcSBbIL1eeCQMVxxv4ViEa4wOBwOvFSGHK9NJ2IyJ85yMioYnInKPS4_ErVZwcOX1S8hleDI9a1Vn0ib1OXB-cKbQC6IIoWeBgjYa3iJqlLZew3zRBHVLmQX-1DRI2lD36mEjx8KATNLb796ZKyutGBtoNwEbOA3J-P8Crl-m9buyQp72hIHOh-9N_5mefcdO19j_yPw8vnhs-F_HzjTg1dXSANcKdtzr14XoSM_kseikkcVMNVrpZeCmrRm0pX59eN9cNghQMKMdQBqoMyj2vyqnxUofyMCh3WL-F3r_dcQ8ohpCOfKNR5h2mocd6t3Z65URaCcxMg38psoCq2678ZRNvWi6SqqBKX0RhYo5TTn-dLEaYDjufC9RV1Wg7baxxmPdRkboKkfN9-ujyUe6T2rUsopQokHHPJH4cbAexHKd2KCgy7OzKQsTdQwKf89hAtZ8HlJSg0SyvforqPZs2vknpXaK3DMVJ8cbSQURl47SzQ5IN98IzxYwpuvRNN7j1JrAsfx7T8nSMTVWDrzJNhimZ41fUIcXdysWUSS76Tzz_tNvZx-4dzRJhs_)

**Note:** See HEALTHCHECK note below.

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
- HEALTHCHECK is a complicated issue.  A discussed in the [OCI's image spec](https://github.com/opencontainers/image-spec/issues/749) project. This is an container instance issue not an image specification.  This note is just here for future reference and should be documented in the architecture.











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

