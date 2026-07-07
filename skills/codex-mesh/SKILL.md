---
name: codex-mesh
description: Local Codex multi-agent terminal transport and Beads coordination workflow. Use when Codex needs to spawn, jump, or tell addressed Codex terminal agents; inspect active mesh agents; join live terminal state with Beads; evaluate goal predicates; install or use the codex-mesh command surface; work in the codex-mesh repository; or start any substantive multi-step task in a mesh workspace and decide between solo execution and orchestrating agents.
---

# Codex Mesh

## Overview

Use codex-mesh as the live terminal transport layer around Beads. Beads owns
durable task orchestration; codex-mesh owns kitty/Codex process launch,
addressed prompt delivery, raw transcripts, live status exposure, and local
goal-predicate checks.

## Orchestrate By Default

`#OrchestrationDefault` pins the operating posture: substantive work defaults
to workflow orchestration, not solo execution. Substantive means multi-step,
mutating, or coverage-shaped — features, reviews, audits, migrations,
research sweeps. Solo execution is valid only for the named exceptions: a
conversational reply, a single-read lookup, a trivial mechanical edit, or
emergency transport recovery. Working solo on anything else violates the
contract; it is not a judgment call.

The default loop:

1. Decompose into a Beads epic with a formula: `bd mol pour <formula>`
   (preview with `bd mol wisp create <formula> --dry-run`).
2. Freeze a `#GoalPredicate` per task and red-check it before any work:
   `mesh goal check --phase red-check PREDICATE.json`.
3. Dispatch bounded role waves: `mesh wave dispatch REQUEST.json`, or
   interpret the formula with `mesh workflow plan|run REQUEST.json`. Mutating
   waves use worktree isolation; merge serialization stays with Beads merge
   slots.
4. Close each task only on a green evaluation plus a `#ResultEnvelope`.
5. Before declaring the epic done, run the closing critics: `loop-until-dry`
   until the ready frontier stays empty, then `completeness-critic`.

Pick the formula by task shape:

| Shape | Formula |
| --- | --- |
| Build or change a feature | `cue-first-feature` |
| Review, audit, or defect sweep | `review-wave` |
| Wide solution space, contested design | `judge-panel` |
| Unknown-size discovery (bugs, edge cases) | `loop-until-dry` |
| "Is anything missing?" before closeout | `completeness-critic` |

Red flags — these thoughts mean stop and pour a formula:

| Rationalization | Reality | mesh-mpl live probe count |
| --- | --- | --- |
| "Too simple to orchestrate" | If it is mutating or multi-step, it is substantive. A wave of one is still verified. | 0 |
| "Dispatch overhead is too high" | The concurrency cap bounds cost; skipped work is reported in `#WaveStatus`, never silent. | 0 |
| "I'll verify at the end" | Red-check comes before work; close requires green plus an envelope. | 0 |
| "It looks complete" | `completeness-critic` is the definition of complete, not a feeling. | 0 |

mesh-mpl live probe (2026-07-06): 0 solo-work rationalizations observed in
`/home/galeavenworth/.local/state/codex-mesh/transcripts/13.ansi`. The fresh
probe chose the formula path, dry-ran `bd mol wisp create cue-first-feature`,
and named the requested launch-policy feature as CUE-first molecule work.

## Roles

Every dispatched agent carries a role in `codex_role` and must return a
`#ResultEnvelope`; prose-only results fail closed.

| Role | Duty | Required payload |
| --- | --- | --- |
| `implementation` | Make the change, prove it with verification evidence | `#ImplementationResult` |
| `reviewer` | Find defects; report severities and locations | `#ReviewFindings` |
| `judge` | Weigh evidence, return pass/fail with rationale | `#Verdict` |
| `probe` | Independently attempt to refute a claim | `#Verdict` |

Worker discipline: when spawned with a `/goal ...` prompt, red-check the
frozen predicate first, iterate against it, and close green with the envelope.
Durable handoff context goes in the Beads issue, never in kitty vars.

## Install First

Prefer the installed command surface when working outside the repo:

```bash
make doctor
make install
make verify
```

`make doctor` reports missing prerequisites without installing third-party
tools. `make install` links `spawn`, `tell`, `jump`, and `mesh` into
`${PREFIX:-$HOME/.local}/bin`, and links this skill into
`${CODEX_HOME:-$HOME/.codex}/skills`. In a contributor checkout, repo-local
script paths are acceptable fallbacks: `scripts/spawn`, `scripts/tell`,
`scripts/jump`, and `scripts/mesh`.

Hard dependencies for runtime use are `bash`, `python3`, `jq`, `git`, `bd`,
`kitty`, and the `codex` CLI. Verification also requires `cue`. `make install`
does not install those dependencies; it installs only codex-mesh links and the
skill. Beads remotes, secrets, and infrastructure provisioning are
operator-owned configuration and are not part of this public skill.

## Work Loop

For repository changes:

```bash
bd prime
bd ready
bd show <id>
bd update <id> --claim
```

Follow the repo's CUE-first order: update `model/contract.cue`, add valid and
adversarial fixtures under `model/fixtures/`, wire them into
`scripts/verify.sh`, then change behavior. Run `./scripts/verify.sh` or
`make verify` before closeout.

## Commands

- `mesh init [--prefix PREFIX] [--remote URL] DIR`: initialize a Beads-backed
  mesh-root coordinator repo; the remote URL is operator configuration.
- `mesh doctor [--json]`: report runtime and verification prerequisites without
  installing third-party tools.
- `spawn [directory] [message...]`: create a new addressed Codex agent and keep
  the initiator alive.
- `spawn --isolation worktree --worktree-base DIR ...`: launch with a
  deterministic private git worktree cwd.
- `tell ADDR [message...]`: send one normal user prompt to exactly one resolved
  live agent; zero or multiple matches fail closed.
- `jump [directory] [message...]`: hand off to a confirmed successor and then
  close the initiating kitty window.
- `mesh agents [--json]`: expose active mesh terminal agents from live kitty
  state and transcript metadata.
- `mesh status [--json]`: join one live-agent query with one Beads status
  snapshot at read time.
- `mesh watch [--once] [--json|--ndjson] [--mesh-root DIR]`: render running
  mesh agents as an operator table or emit `#WatchSnapshot` JSON/NDJSON for
  controller agents.
- `mesh context bind --mesh-root DIR [--listen-on ADDRESS]`: bind a mesh root
  to one kitty `listen_on` socket so fresh shells target the same mesh context.
- `mesh context show|resolve [--mesh-root DIR] [--json]`: inspect the resolved
  kitty target before acting.
- `mesh goal check [--phase red-check|iteration|close] PREDICATE.json`:
  evaluate a frozen `#GoalPredicate` locally and emit `#GoalEvaluation` JSON.
- `mesh wave dispatch REQUEST.json`: launch a bounded invoked pass over one
  Beads-ready frontier and emit `#WaveStatus` JSON.
- `mesh wave status REQUEST.json`: report the wave plan without launching.
- `mesh workflow plan|run|status REQUEST.json`: interpret a Beads formula into
  a bounded `#WorkflowRun` with explicit repo/task/role placement, isolation,
  visible runner decisions, and result-envelope close policy.
- `bd formula list`: list repo-local Beads formulas under `.beads/formulas`.
- `bd mol wisp create <formula> --dry-run`: verify a formula can instantiate
  without mutating Beads state.

## Boundaries

Use Beads for task DAGs, readiness, claiming, durable handoff context,
comments, lifecycle state, gates, swarms, formulas, merge slots, and the
mesh-level coordinator repo when a mesh root is itself Beads-backed. `mesh init`
may create that root and optionally pass an operator-provided remote URL to
Beads, but remote hosting remains outside codex-mesh. Do not invent Beads
subcommands; verify the installed `bd` surface directly before pinning a
primitive in `#CurrentBeadsPrimitive`.

Use codex-mesh only for live terminal transport: kitty launch, logical address
resolution, prompt delivery, parent-window close, transcript capture, live
agent exposure, local predicate evaluation, and bounded invoked wave dispatch.
Do not store PIDs, window ids, cwd, liveness, idle state, or wave resume state
in a database. Durable history is raw transcripts plus Beads lifecycle edges.
For mutating waves, use worktree isolation and leave merge serialization to
Beads merge-slot primitives.

Use `mesh watch` for current reality, not historical truth. It is made first for
the operator and second for controller agents. Its states are mechanical:
`active`, `quiet`, `detached`, and `orphan`. It must not infer intent, and token
or dollar budgets stay out of scope until Codex exposes a stable local metric
surface. It must run from outside a Beads workspace. Use `CODEX_MESH_ROOT` or
`--mesh-root DIR` to scan the mesh root plus direct child project directories.
If the mesh root has `.beads`, it is surfaced as the `mesh-root` coordinator
workspace. Child directories are surfaced as `project` workspaces; projects
without Beads are surfaced as `missing` instead of crashing the watch. Default
rows are running mesh agents only; use `--include-detached` only when you
explicitly need Beads tasks without live terminals as rows.

Bind a mesh root once with `mesh context bind --mesh-root DIR` from the kitty
context that should own the mesh agents, or pass `--listen-on ADDRESS`
explicitly. Runtime target resolution is: `CODEX_MESH_KITTY_LISTEN_ON`, bound
mesh-root config, longest configured root containing cwd, current
`KITTY_LISTEN_ON`, then current kitty. Do not scan `/tmp/kitty-*` as the
substrate; socket scanning is diagnostic-only. The binding stores only
`mesh_root` and `kitty_listen_on`, never window ids, PIDs, liveness, or agent
state.

The repo ships Beads formulas for `cue-first-feature`, `review-wave`,
`judge-panel`, `loop-until-dry`, and `completeness-critic`. Treat them as
Beads-owned workflow templates with mesh-validated goal metadata, not as
codex-mesh-owned lifecycle state. `mesh workflow` can plan, run in dry-run mode,
and report status for formula steps by emitting `#WorkflowRun`, `#FormulaRun`,
`#WorkflowStepState`, and `#RunnerDecision`. It must not persist runner state,
close Beads tasks, or hide child dispatch. Same-repo delegation is valid only
when placement is explicit: read-only work may share a checkout, mutating work
uses deterministic worktrees unless an explicit main-owned merge/coordinator
step holds Beads merge-slot jurisdiction, and every dispatch decision names the
target repo, task id, role, isolation mode, communication channel, and reason.

Goal-loop dispatch should be predicate-first, not step-list-first: red-check
before work, iterate against the same frozen predicate, and close only with a
green evaluation plus a `#ResultEnvelope` carrying predicate evidence.

Public deployments should depend on installed commands and this skill. Remote
names, self-hosted Beads servers, secrets, and infrastructure tokens stay
outside the public repo and outside this skill.
