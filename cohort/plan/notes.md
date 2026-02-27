# README Planning Notes — 2026-02-27

- **Planner:** Blair Fontaine
- **Plan branch:** `plan/readme-refresh`
- **Objective:** Apply the `plan-readme` protocol so this base image has a production-ready README + handoff assets.

## Branch inventory
| Branch | Status |
| --- | --- |
| `main` | Tracks released container definitions. Up to date with origin. |
| `dev` | Active integration branch; README work will merge here first. |
| `plan/readme-refresh` | Current planning branch for README upgrades. |

## Issue audit (open items)
| # | Title | Notes |
| --- | --- | --- |
| #102 | Entrypoint bug | Needs repro & fix plan; README should reference the entrypoint contract once resolved. |
| #95 | Issue with backup script | Downstream users need clarity on overriding `container_backup`; document default behavior. |
| #77 | Setup a full machine proxy | Future enhancement; call out in README planning hooks. |
| #43 | Add the check scripts for status | Ties into health probes; surface current default + TODOs. |

## README gaps identified
1. Only two paragraphs existed — no setup, branch model, or health/backup guidance.
2. No documentation for the bundled helper scripts (backup, health, version, privileges).
3. Lacked deployment/testing instructions (Podman build, health checks, volume expectations).
4. No link to open work or the planning branch.

## Actions
- Expand README to cover overview, architecture, environments, setup, operations, planning hooks, and contacts per protocol.
- Reference the pending issues above so Adam can track README-driven follow-ups.
- After README + notes committed, push branch, open PR to `dev`, assign Adam, and add project item in "Ready".
