# Alpine Base Container

> Upstream Alpine Linux distilled into a batteries-included base image for every downstream Eureka FARMS workload.

## Overview
| Item | Details |
| --- | --- |
| Owner | Adam Gautier / Blair Fontaine (planning) |
| Purpose | Provide a hardened Alpine 3.22 base image with consistent backup, health, privilege, and entrypoint conventions for child containers. |
| Registry | `gautada/alpine` (built via this repo’s `Containerfile`) |
| Status | **Ready** — README plan branch: `plan/readme-refresh` |

This repository seeds every other container image in the fleet. It standardizes:
- Volume layout under `/mnt/volumes/{data,configmaps,backup,secrets}`
- Default backup + health scaffolding that child images can override
- s6-based init + privilege model so services come up the same way everywhere

## Architecture
```
+---------------------------+
| Downstream container      |
|  (inherits FROM this)     |
|    Custom services        |
+-------------+-------------+
              ^
              |
+-------------+-------------+
| gautada/alpine base image |
|  • s6 init + entrypoint   |
|  • Health proxy scripts   |
|  • Backup + cron wiring   |
|  • Privileged user group  |
+-------------+-------------+
              ^
              |
+-------------+-------------+
| docker.io/library/alpine  |
+---------------------------+
```
- PlantUML source: [`architecture.puml`](./architecture.puml)
- Init manager: `s6-svscan` (see `ENTRYPOINT` in `Containerfile`)
- Health fan-out: `/usr/bin/container-{liveness,readiness,startup,test}` symlink to `container-health`

## Branch & Release Model
| Branch | Use |
| --- | --- |
| `dev` | Integration branch; all plan/README work merges here first. |
| `main` | Mirror of released container definitions. |
| `plan/*` | Short-lived planning/README efforts (current: `plan/readme-refresh`). |

Create releases by merging tested changes into `main`, then tagging + pushing to the registry pipeline.

## Local Setup
1. **Clone & hydrate**
   ```bash
   git clone https://github.com/gautada/alpine.git
   cd alpine
   git fetch --all --prune
   git checkout dev
   ```
2. **Prerequisites**
   - Podman 5+ or Docker 24+
   - `gh` CLI (for issues/PRs)
   - Internet access to pull Alpine mirrors (mirror default: Princeton)

## Build & Test
| Task | Command |
| --- | --- |
| Build image | `podman build -t gautada/alpine:dev -f Containerfile .` |
| Run shell | `podman run --rm -it gautada/alpine:dev /bin/zsh` |
| Execute health proxy | `podman run --rm gautada/alpine:dev /usr/bin/container-health` |
| Capture version | `podman run --rm gautada/alpine:dev /usr/bin/container-version` |

Volumes `/mnt/volumes/{data,configmaps,backup,secrets}` are declared; mount host paths or Kubernetes PVCs there when testing child containers.

## Customizing for Downstream Images
### Backup contract
- Default implementation lives in [`backup.sh`](./backup.sh) and simply logs + drops a timestamp into `data`.
- Downstream images should provide `/etc/container/backup` with a real `container_backup()` function or mount a config map overriding the script.

### Health checks
- [`container-health.sh`](./container-health.sh) unifies startup, readiness, liveness, and `container-test` entrypoints.
- To add bespoke checks, copy scripts into `/etc/container/health.d/*.health` or override `/etc/container/{liveness,readiness,startup}` in your derived image.

### Privileges & users
- [`privileges`](./privileges) is symlinked into `/etc/sudoers.d/privileges`.
- Default user: `alpine` (`UID=1001`, member of `privileged` group). Change via build args `USER`, `UID`, `GID`.

### Entry points & init
- s6 watches `/etc/services.d/*/run`; add your service definitions there via the downstream `Containerfile`.
- Custom entrypoints can replace `/usr/bin/s6-svscan` by overriding `ENTRYPOINT` in the child image if needed.

## Operations Playbook
| Scenario | Steps |
| --- | --- |
| **Run backup manually** | `podman run --rm gautada/alpine:dev /etc/container/backup` (override script before running). |
| **Rotate timezone** | Update `/etc/timezone` (defaults to `America/New_York`) then relink `/etc/localtime`. |
| **Add cron health checks** | Drop scripts under `/etc/container/health.d` (see commented `cron.health.sh` & `os-health.sh`). |
| **Update Alpine mirror** | Edit the `sed` line in the `Containerfile` if the Princeton mirror ever lags. |

## Planning Hooks & Open Work
- **Plan branch:** `plan/readme-refresh` (holds README + notes updates).
- **Open issues influencing docs:**
  - #102 Entrypoint bug — document final behavior once patch lands.
  - #95 Backup script improvements — README now emphasizes overriding the default.
  - #77 Full machine proxy — downstream guidance will link here once design is approved.
  - #43 Additional status scripts — reference `container-health` scaffolding.
- Keep the `plan-readme` topic until PR merges; remove afterwards.

## Contact
| Role | Person |
| --- | --- |
| Product / Infra owner | Adam Gautier (@gautada) |
| Planning / README upkeep | Blair Fontaine (@blairfontaine) |
| Execution follow-up | Nyx Calder (@nyxcalder) |

Need help? Drop a note in Slack or open an issue — include logs from `/usr/bin/container-health` when reporting runtime problems.
