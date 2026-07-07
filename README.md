# codex-mesh

`codex-mesh` is a small CUE-first command surface for local Codex
multi-agent work over kitty remote control.

## Install

For a first-time setup, start with the getting-started guide:

```sh
make doctor
make install
```

`make doctor` reports missing prerequisites. It does not install third-party
tools for you. See [Getting Started](docs/getting-started.md) for the full
first-run sequence and dependency policy.

For regular use, install the command surface and agent skill:

```sh
make install
```

This links `spawn`, `tell`, `jump`, and `mesh` into
`${PREFIX:-$HOME/.local}/bin`, and links the repo-local skill at
`skills/codex-mesh` into `${CODEX_HOME:-$HOME/.codex}/skills`. Runtime use
requires `kitty`, `codex`, `bd`, `jq`, and `python3`; verification also requires
`cue`. `git` is required for repository-root detection and mesh-root
initialization.

`make install` intentionally does not install `kitty`, `codex`, `bd`, `cue`, or
operating-system packages. Those are prerequisites owned by the user or the
operator's environment.

## Commands

- `mesh init [--prefix PREFIX] [--remote URL] DIR` initializes a Beads-backed
  mesh-root coordinator repo without hardcoding a remote provider.
- `mesh doctor [--json]` reports runtime and verification prerequisites without
  installing third-party dependencies.
- `spawn [directory] [message...]` creates an addressed Codex agent and keeps
  the initiator alive.
- `spawn --isolation worktree --worktree-base DIR ...` launches with a
  deterministic private git worktree cwd.
- `tell ADDR [message...]` sends a normal user prompt to exactly one running
  addressed agent.
- `jump [directory] [message...]` hands off to a successor agent and closes the
  initiating kitty window after the successor is confirmed.
- `mesh agents [--json]` exposes active addressed agents from live kitty state.
- `mesh status [--json]` joins active agents with the Beads status snapshot.
- `mesh watch [--once] [--json|--ndjson] [--mesh-root DIR]` renders running
  mesh agents for an operator or emits CUE-shaped watch snapshots for tools.
- `mesh context bind --mesh-root DIR [--listen-on ADDRESS]` binds a mesh root
  to one kitty remote-control socket for fresh shells and non-kitty terminals.
- `mesh context show|resolve [--mesh-root DIR] [--json]` shows the kitty target
  the command surface will use.
- `mesh session render --profile operator [--mesh-root DIR]` emits an operator
  `.kitty-session` file from the same read-time watch snapshot used by
  `mesh watch`; it opens operator views and workspace shells, and does not
  relaunch addressed agents or store `codex_*` user variables.
- `mesh goal check [--phase red-check|iteration|close] PREDICATE.json`
  evaluates a frozen goal predicate and emits `#GoalEvaluation` JSON.
- `mesh wave dispatch REQUEST.json` spawns a bounded pass over a Beads ready
  frontier and emits `#WaveStatus` JSON.
- `mesh wave status REQUEST.json` reports the same wave plan without launching
  agents.
- `mesh workflow plan|run|status REQUEST.json` interprets a Beads formula into
  a bounded `#WorkflowRun` plan with explicit repo, task, role, placement,
  isolation, communication channel, and result-envelope close policy.

## Formula Library

Repo-local Beads formulas live in `.beads/formulas` and are visible through:

```sh
bd formula list
bd mol wisp create review-wave --dry-run
bd mol pour cue-first-feature --dry-run
```

The shipped formulas are `cue-first-feature`, `review-wave`, `judge-panel`,
`loop-until-dry`, and `completeness-critic`. They are Beads workflow templates,
not codex-mesh schedulers; each step carries goal metadata that is verified by
`model/contract.cue`.

`mesh workflow` is the public runner surface over those formulas:

```sh
mesh workflow plan model/fixtures/valid-workflow-request-review-wave.json
mesh workflow run model/fixtures/valid-workflow-request-review-wave.json
mesh workflow status model/fixtures/valid-workflow-request-review-wave.json
```

In this first runtime, `run` is still bounded and dry-run: it emits decisions
instead of launching hidden workers or mutating Beads. A decision must name the
target repo, Beads task id, role, cwd/placement key, isolation mode,
communication channel, and reason. Multiple agents may target the same repo id:
read-only steps can share a checkout, mutating steps use deterministic worktree
placement, and main-checkout mutation requires explicit jurisdiction plus Beads
merge-slot coordination.

The lifecycle commands use kitty user variables as the logical addressing
layer. The kitty numeric window id is only a transport handle.

## Beads Boundary

Beads owns durable multi-agent coordination:

- task DAGs, readiness, claiming, assignment, comments, labels, and statuses
- swarm status for epic-shaped parallel work
- gates, merge slots, and multi-repo hydration/configuration
- the mesh-level coordinator repo when the mesh root itself has `.beads`
- molecule/formula workflow templates and repository coordination

`codex-mesh` owns only the live Codex terminal transport:

- launching a Codex process in kitty
- registering `codex_addr`, `codex_role`, `codex_parent`, and `codex_task`
  as kitty user variables
- resolving exactly one live `codex_addr` before prompt delivery
- binding a mesh root to one explicit kitty `listen_on` target for deterministic
  operator visibility across fresh shells
- exposing active terminal agents, their cwd, live process handle, transcript
  pointer, and output-idle state
- joining that live terminal snapshot with one Beads status snapshot at read
  time
- closing the initiating kitty window after a confirmed `jump`

`codex_task` is a Beads issue id. Handoff context belongs in Beads; the kitty
variable is only the live process pointer back to that durable issue.

Goal loops stay on the same boundary. Beads owns the task lifecycle and durable
attachments; codex-mesh only evaluates the local `#GoalPredicate` command and
packages evidence. A dispatch should start with a red check, iterate until the
same predicate is green, and close only with a `#ResultEnvelope` carrying that
evidence.

Wave dispatch also stays on that boundary. `mesh wave dispatch` consumes the
Beads ready frontier for one epic, launches at most the request cap, and leaves
readiness, closure, gates, swarms, and resume semantics in Beads. A closed bead
is never re-dispatched because the frontier is Beads state, not mesh memory.
Mutating waves must use worktree isolation; merge serialization stays with
Beads `merge-slot` primitives, and codex-mesh never merges branches.

Workflow planning follows the same boundary. `mesh workflow` reads Beads formula
JSON and emits `#WorkflowRun`, `#FormulaRun`, `#WorkflowStepState`, and
`#RunnerDecision` records. It does not persist runner state, create hidden child
workers, close Beads tasks, or encode provider-specific remotes or secrets.
Close decisions require a green predicate and a `#ResultEnvelope` joined to the
same Beads task id.

Live agent visibility is not stored in a separate database. `mesh agents`
queries kitty and transcript file metadata at read time. `mesh status` performs
one live-agent read and one `bd list --status=open,in_progress,hooked --json`
read, then joins by `codex_task`. PIDs, window ids, current cwd, and last-output
age are ephemeral exposure. Transcripts are the raw durable record of terminal
output; Beads is the durable task/coordination layer.

`mesh watch` is the operator view over that same read-time seam. It runs from
any directory; the caller cwd does not need a Beads database. By default, watch
uses the caller cwd as one workspace candidate. Set `CODEX_MESH_ROOT` or pass
`--mesh-root DIR` to scan the mesh root and direct child directories, one level
only:

```sh
CODEX_MESH_ROOT=$HOME/lab mesh watch
mesh watch --mesh-root "$HOME/lab" --once --json
```

The public workspace shape is a Beads-backed mesh-root repo containing
Beads-backed project repos:

```text
mesh-root/
  .beads/                 # mesh-level coordinator: cross-project epics/policy
  project-a/
    .beads/               # project-owned implementation work
  project-b/
    .beads/
```

The mesh-root Beads repo owns durable cross-project coordination. Child project
repos own their implementation beads. `codex-mesh` does not create or provision
the Beads remote for that root; remote names, credentials, and hosting are
operator configuration. Public consumers can use any Beads/Dolt remote strategy
that their environment supports.

Initialize that container explicitly:

```sh
mesh init "$HOME/lab" --prefix lab
mesh init "$HOME/lab" --prefix lab --remote "$BEADS_REMOTE_URL"
```

`--remote` is passed through as operator configuration. It can point at hosted
Dolt, self-hosted infrastructure, or be omitted for local-only setup.

For durable operator ergonomics, bind that mesh root to the kitty remote-control
socket that should own mesh agents:

```sh
mesh context bind --mesh-root "$HOME/lab"
mesh context show --mesh-root "$HOME/lab" --json
```

`mesh context bind` uses `--listen-on`, `CODEX_MESH_KITTY_LISTEN_ON`, or the
current `KITTY_LISTEN_ON`. Later `mesh watch --mesh-root "$HOME/lab"` calls
`kitty @ --to <bound-socket> ls`, so a fresh kitty window or non-kitty terminal
does not accidentally watch its own empty kitty context. The binding stores only
operator config: mesh root and kitty `listen_on`. It does not store window ids,
PIDs, liveness, or agent state.

Each discovered workspace reports `workspace_role` as `mesh-root` or `project`
and `beads_status` as `available`, `missing`, `error`, or `unknown`. If the
mesh root itself has `.beads`, it is surfaced first as the `mesh-root`
coordinator workspace. Child directories are surfaced as `project` workspaces.
Workspaces with `.beads` are queried with
`bd -C <workspace> list --status=open,in_progress,hooked --json`; workspaces
without Beads are still surfaced as `missing`.

Default watch rows are running mesh agents only. Bead, project, Beads status,
cwd, and transcript path are columns on those agent rows. Rows use mechanical
states: `active` for recent transcript output on a live task, `quiet` for a
live task without recent/known output, and `orphan` for a live terminal without
a matching Beads task. `detached` Beads tasks are hidden by default; pass
`--include-detached` when you explicitly want Beads work without live terminals
included as rows. `mesh watch --once --json` emits one `#WatchSnapshot`; `mesh
watch --ndjson` emits one compact snapshot per refresh tick for controller
agents. It does not infer "thinking" or "stuck", and it does not track token or
dollar budgets.

## Transcripts

Every `spawn` and `jump` session gets a raw PTY transcript by default. The
transcript records the terminal output byte stream for that Codex process:
stdout, stderr, ANSI redraws, and anything else the child process emits to its
terminal. It does not separately record stdin, so input that a program does not
echo is not added by codex-mesh.

Transcript files default to:

```sh
${XDG_STATE_HOME:-$HOME/.local/state}/codex-mesh/transcripts/<kitty-window-id>.ansi
```

The path is also exposed to the child as `CODEX_MESH_TRANSCRIPT` and
`codex_transcript`; the shared id is exposed as `CODEX_MESH_SESSION_ID` and
`codex_session`. Set `CODEX_MESH_TRANSCRIPT_DIR` to choose a different
directory. Set `CODEX_MESH_TRANSCRIPT_DISABLE=1` only for explicit emergency or
test cases.

The generated Beads v1.1.0 CLI reference does not include `bd routes`,
`bd pin`, `bd hook`, `bd agents`, `bd reserve`, or `bd lock`. Current scripts
must use the verified local primitives (`bd ready`, `bd show`,
`bd update --claim`, `bd assign`, `bd comment`, `bd comments`, `bd note`,
`bd list --status=open,in_progress,hooked --json`,
`bd -C <workspace> list --status=open,in_progress,hooked --json`, `bd swarm`,
`bd gate`, `bd merge-slot`, `bd repo`, `bd mol`, and `bd formula list`).

## Contract

The command semantics live in `model/contract.cue`. Verification requires valid
fixtures to pass and adversarial fixtures to fail closed:

```sh
./scripts/verify.sh
```

## Current Backend

The first backend is kitty remote control:

```sh
kitty @ --to "$KITTY_LISTEN_ON" launch --type=os-window --hold --title "$addr" \
  --var "codex_addr=$addr" \
  --cwd "$workdir" \
  bash -lc 'exec "$CODEX_MESH_RECORDER" "$CODEX_MESH_TRANSCRIPT_DIR" codex --yolo "$@"' codex "$message"
```

Future backends should preserve the same CUE contract and change only the
transport adapter.
