# Getting Started

`codex-mesh` is a local command surface for Codex agents running in kitty, with
Beads as the durable task layer. Installation is intentionally split into two
parts:

1. Install third-party prerequisites.
2. Link the codex-mesh commands and skill from this checkout.

`make install` only performs the second step. It does not run a package manager,
request sudo, install kitty, install Beads, install Codex, or provision remotes.

## Prerequisites

Runtime use requires:

- `bash`
- `python3`
- `jq`
- `git`
- `bd`
- `kitty`
- `codex`

Verification also requires:

- `cue`

Install these with the package manager or upstream installer appropriate for
your machine. Beads remotes, credentials, and hosting are operator
configuration, not codex-mesh public defaults.

Check the local machine:

```sh
make doctor
mesh doctor --json
```

`mesh doctor --json` emits the CUE-verified `#InstallDoctor` shape so scripts
and publication gauntlets can fail closed on missing prerequisites.

## Install

From the repository root:

```sh
make install
```

This links:

- `spawn`, `tell`, `jump`, and `mesh` into `${PREFIX:-$HOME/.local}/bin`
- `skills/codex-mesh` into `${CODEX_HOME:-$HOME/.codex}/skills/codex-mesh`

Use `PREFIX` or `BINDIR` to choose another command location:

```sh
make install PREFIX="$HOME/.local"
make install BINDIR="$HOME/bin"
```

## First Mesh

Start kitty with remote control enabled. One durable convention is to name the
socket after the mesh root:

```sh
kitty --single-instance --instance-group mesh-lab --listen-on unix:@mesh-lab
```

Initialize or select a Beads-backed mesh root:

```sh
mesh init "$HOME/lab" --prefix lab
mesh context bind --mesh-root "$HOME/lab" --listen-on unix:@mesh-lab
mesh context show --mesh-root "$HOME/lab" --json
```

Then watch the mesh:

```sh
mesh watch --once --mesh-root "$HOME/lab"
```

If you use a remote Beads/Dolt authority, pass it as operator configuration:

```sh
mesh init "$HOME/lab" --prefix lab --remote "$BEADS_REMOTE_URL"
```

Public codex-mesh does not assume a remote provider, control-plane project,
password manager, vault name, or any specific secret system.

## Verify

For contributor work:

```sh
make verify
```

This checks the CUE contract, valid and adversarial fixtures, command help,
formula dry-runs, and offline command behavior.

The same checks can be run by tier:

```sh
make verify-contract
make verify-offline
make verify-runtime
```

`verify-contract` runs CUE contract and fail-closed fixture checks.
`verify-offline` runs fixture-driven command behavior without live terminal
launches. `verify-runtime` runs repo-owned Beads formula dry-runs and command
surface checks. It must not depend on maintainer-local Beads issue or molecule
ids that are not tracked in this checkout.
