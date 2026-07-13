# Threat Model and Safety Boundaries

`codex-mesh` is a local command surface for Codex agents running in kitty, with
Beads as the durable task layer and CUE as the contract layer. This document
describes the trust assumptions and safety boundaries of the current public
project. It does not add new runtime behavior.

## Scope

This document covers the public `codex-mesh` command surface in this repository:
`spawn`, `tell`, `jump`, and `mesh`, plus the CUE contracts, fixtures, formulas,
transcript recorder, and documentation shipped with the repo.

It does not cover private operator infrastructure, private plugins, hosted
control planes, credential stores, or Beads/Dolt remotes configured outside this
repository. Those are operator-owned concerns.

## Trust Assumptions

`codex-mesh` is designed for a trusted local operator environment. It assumes:

- the operator controls the checkout, shell, kitty instance, Codex CLI, Beads
  CLI, and local filesystem where commands run;
- third-party prerequisites are installed and updated by the operator, not by
  `codex-mesh`;
- the kitty remote-control socket selected by `KITTY_LISTEN_ON`,
  `CODEX_MESH_KITTY_LISTEN_ON`, or `mesh context bind` is trusted by the
  operator;
- Beads is the durable source of task truth;
- CUE validation and fail-closed fixtures define the public command contracts;
- transcripts are local artifacts that may contain sensitive terminal output.

The current launch adapter starts Codex through kitty. In
`scripts/codex-mesh-lib.sh`, the launch path invokes `codex --yolo`. That is a
local trust decision: the project currently starts child Codex sessions with
that Codex mode, and operators should treat launched agents as having broad
authority consistent with their local Codex configuration and shell access.

## Ownership Boundaries

Beads owns durable coordination:

- task identity, readiness, status, claims, assignments, comments, gates, swarms,
  merge slots, formulas, and remote sync;
- the `codex_task` issue id that links a live terminal session back to durable
  work;
- workflow closeout evidence stored as Beads state or attachments outside the
  live terminal process.

`codex-mesh` owns live terminal transport and read-time exposure:

- launching Codex in a kitty OS window;
- setting kitty user variables such as `codex_addr`, `codex_role`,
  `codex_parent`, `codex_task`, `codex_session`, and `codex_transcript`;
- resolving exactly one live `codex_addr` before `tell` sends a prompt;
- confirming a successor before `jump` closes the initiating window;
- exposing live agents, cwd, process metadata, transcript paths, and Beads joins
  at read time through `mesh agents`, `mesh status`, and `mesh watch`.

kitty owns the terminal transport:

- window creation, window ids, user variables, remote-control commands, and text
  delivery into terminal sessions.

Codex owns agent behavior inside the launched terminal process:

- model interaction, command execution behavior, approval behavior, and any
  effects produced by the Codex CLI according to its local configuration.

CUE owns the public contract surface:

- command record shapes, workflow records, result envelopes, goal predicates,
  live authorization records, watch snapshots, formulas, fixtures, and
  fail-closed validation.

## Non-Goals

`codex-mesh` is not a security sandbox. Worktree isolation is not process,
network, credential, kernel, container, or filesystem sandboxing. A worktree is
a Git checkout placement strategy for coordinating mutating work and keeping
concurrent edits separated; it does not by itself restrict what a process can
read, write, execute, or access.

`codex-mesh` is not a durable scheduler or daemon. `mesh status` and
`mesh watch` perform read-time joins between live terminal state and Beads task
state. `mesh wave dispatch` and `mesh workflow` are bounded invoked command
surfaces. The project should not persist window ids, PIDs, idle state, or live
liveness as a separate source of workflow truth.

`codex-mesh` is not a secret manager or hosted control plane. Public workflow
records reject provider-specific secrets and fields such as `remote_provider`,
`secret_ref`, `credential`, and `private_origin`. Operators may configure
private infrastructure outside the public core, but those details should not
become public workflow authority.

## Transcript Privacy

Every `spawn` and `jump` session records a raw PTY transcript by default unless
`CODEX_MESH_TRANSCRIPT_DISABLE=1` is set. The recorder writes terminal output
bytes to an `.ansi` file. It mirrors child process output and terminal redraws;
it does not separately record stdin, so input that a program does not echo is
not added by `codex-mesh` as a separate semantic input log.

The default transcript directory is:

```sh
${XDG_STATE_HOME:-$HOME/.local/state}/codex-mesh/transcripts
```

The code creates transcript directories with mode `700` and transcript files
with mode `600` where the local filesystem honors POSIX modes. Those file modes
are local filesystem controls, not a cross-platform secrecy guarantee.

Operators should treat transcripts as sensitive local artifacts. They can
contain command output, file contents printed in the terminal, error messages,
paths, environment-derived output, copied text, and other data emitted by
programs running inside the Codex session.

## Environment Propagation

`spawn` and `jump` pass selected metadata into child sessions through kitty
environment variables and user variables. Current variables include agent
address, role, optional parent, optional Beads task id, optional mesh root,
transcript directory, selected kitty listen socket, and `KITTY_PUBLIC_KEY` when
present.

These variables are coordination metadata. They should not be used for
credential transport, and public contract records should not add provider
secrets or private operator references.

## Addressing and Prompt Delivery

The logical agent identity is `codex_addr`, not the numeric kitty window id.
`tell` resolves an address against live kitty state and fails unless exactly one
running window matches. This prevents zero-match delivery and ambiguous
multi-window delivery from being treated as success.

The numeric kitty window id is an ephemeral transport handle. It should not be
stored as durable workflow identity.

## Worktree Isolation

Mutating waves and live mutating workflow requests require worktree isolation in
the CUE contract and command behavior. This protects coordination by separating
concurrent edit locations and by keeping merge serialization with Beads-owned
merge-slot work.

Worktree isolation does not protect secrets, constrain system calls, prevent
network access, or isolate processes from the rest of the machine. Operators
who need security isolation must provide it outside `codex-mesh`.

## Live Mutation Guardrails

The live mutation surface is explicitly gated by contract. A live mutating
workflow request must be `dry_run=false`, set `live_mutation=true`, include live
authorization, require worktree isolation, respect project gates, hold public
deployment, define bounded concurrency, and include kill switches such as
`lights_off` and `broadcast_halt`.

The live dispatch policy reuses the existing spawn adapter and keeps durable
state in Beads comments and transcripts. It must not introduce hidden dispatch,
provider-specific credentials, persisted liveness, daemon state, or scheduler
state.

## Result and Closeout Boundary

A task is not complete merely because an agent produced prose. Closeout depends
on role-typed `#ResultEnvelope` records and goal predicate evidence. The
contract maps implementation work to `#ImplementationResult`, reviewer work to
`#ReviewFindings`, and judge or probe work to `#Verdict`. Prose-only results
fail closed.

Goal predicates are frozen, red-checked before work, and must evaluate green
before closeout. This keeps workflow evidence explicit and reviewable rather
than inferred from terminal liveness or optimistic summaries.

## Acceptable Future Extensions

Future extensions should preserve the current boundaries:

- add CUE contract definitions and valid/adversarial fixtures before or with
  behavior changes;
- keep shell scripts thin transport adapters over contract-shaped records;
- keep telemetry opt-in, local-first, and free of prompt bodies, secrets, and
  transcript contents by default;
- keep Beads as the durable workflow authority;
- keep new backends behind the same public command semantics.

## Unacceptable Future Extensions

The following changes would violate the current safety model unless the project
intentionally adopts a new threat model:

- persisting PIDs, kitty window ids, idle timers, or live liveness as durable
  task truth;
- adding a background scheduler or daemon that owns workflow lifecycle state;
- treating worktree isolation as a security sandbox;
- storing provider secrets, private remotes, credential references, or operator
  validation artifacts in public workflow records;
- delivering prompts to zero or multiple matched addresses as if delivery
  succeeded;
- making transcript capture more invasive without updating the threat model;
- making telemetry mandatory or exporting prompt bodies, secrets, or transcript
  contents by default.
