# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:7510c1e2 -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

**Architecture in one line:** issues live in a local Dolt DB; sync uses `refs/dolt/data` on your git remote; `.beads/issues.jsonl` is a passive export. See https://github.com/gastownhall/beads/blob/main/docs/SYNC_CONCEPTS.md for details and anti-patterns.

## Session Completion

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
<!-- END BEADS INTEGRATION -->

## What This Is

`codex-mesh` is a CUE-first command surface for local Codex multi-agent work
over kitty remote control. Commands: `spawn` (create an addressed agent,
initiator stays alive), `tell` (deliver a prompt to exactly one running
agent), `jump` (hand off to a confirmed successor, then close the initiating
kitty window — not a synonym for spawn), `mesh agents` (expose live mesh agent
state), and `mesh status` (join live mesh agents with one Beads status
snapshot). `mesh goal check` evaluates a frozen goal predicate and emits
`#GoalEvaluation` JSON. `mesh wave dispatch` runs an invoked, bounded pass over
one Beads-ready frontier and emits `#WaveStatus` JSON. `mesh watch` renders the
live status seam as an operator table or CUE-shaped snapshots.

## Install

```bash
make install        # link commands and the repo-local codex-mesh skill
```

The installed skill is `skills/codex-mesh`, linked into
`${CODEX_HOME:-$HOME/.codex}/skills` so future agents discover the workflow.

## Build & Test

```bash
make verify            # wrapper around scripts/verify.sh
./scripts/verify.sh    # the whole quality gate; requires cue, jq, python3, bd
```

`verify.sh` is the definition of "verified": every valid fixture must `cue vet`
green, every adversarial fixture must fail closed, scripts must pass syntax
checks, and resolution/dry-run behavior tests must pass.

Targeted checks while iterating:

```bash
# One fixture against one contract definition
cue vet model/fixtures/valid-spawn.json model/contract.cue -d '#SpawnRequest'

# Address resolution offline, against a canned `kitty @ ls` snapshot
CODEX_MESH_KITTY_LS_FILE=tests/kitty-ls-single.json scripts/tell --resolve-only codex-implementation-1

# Command behavior without launching kitty or codex
CODEX_MESH_DRY_RUN=1 scripts/spawn --addr codex-test --role implementation "$PWD" "hello"
```

Test seams: `CODEX_MESH_DRY_RUN=1` skips real kitty/codex launches;
`CODEX_MESH_KITTY_LS_FILE` substitutes a JSON file for live `kitty @ ls`
output, and `CODEX_MESH_BD_LIST_FILE` substitutes a JSON file for the Beads
status snapshot (fixtures live in `tests/`).

## Architecture

**The CUE contract is the source of truth.** `model/contract.cue` owns command
semantics and fail-closed invariants. The mutation order is fixed:

1. Encode the semantics in `model/contract.cue`.
2. Add a valid fixture AND an adversarial fixture under `model/fixtures/`.
3. Wire both into `scripts/verify.sh` — fixtures are enumerated explicitly
   there, not globbed, so a new fixture that isn't wired in verifies nothing.
4. Only then change script behavior.

**Scripts are thin transport adapters.** `scripts/spawn`, `tell`, `jump`, and
`mesh` share `scripts/codex-mesh-lib.sh` where relevant (validation, address
resolution, kitty launch). `make install` links the command surface into
`~/.local/bin` and the skill into `~/.codex/skills`, so scripts resolve their
own real location before sourcing local helpers. Logic that belongs in the
contract must not accumulate in the scripts.

**Addressing.** Kitty user variables (`codex_addr`, `codex_role`,
`codex_parent`, `codex_task`, `codex_session`, `codex_transcript`) are the
logical address layer; numeric kitty window ids are transport handles only.
`spawn`/`jump`
preflight that the address is not already running (`#AddressPreflight`);
`tell` fails closed on zero or multiple matches (`#TellResolution`); `jump`
closes the initiator only after the successor is confirmed live
(`#JumpResult`, `--no-close` exists for testing).

**Live status.** `mesh agents` and `mesh status` are exposure surfaces, not a
durability layer. `mesh agents` queries kitty plus transcript file metadata at
read time and emits `#LiveAgentSnapshot` records. `mesh status` performs one
live-agent read and one `bd list --status=open,in_progress,hooked --json` read,
then emits a `#MeshBeadsJoin`. Do not store PIDs, window ids, cwd, active/idle
state, or per-agent Beads lookups in a separate database. Durable history is
transcripts plus Beads lifecycle edges.

**Watch.** `mesh watch` emits `#WatchSnapshot`. The default table is for the
human operator; `--once --json` and `--ndjson` are for controller agents. It
runs from any caller directory. Without a mesh root, the caller cwd is a single
workspace candidate and missing Beads is reported instead of failing. With
`--mesh-root DIR` or `CODEX_MESH_ROOT`, watch scans only direct child
directories, marks each workspace `available`, `missing`, `error`, or
`unknown`, and queries tasks with
`bd -C <workspace> list --status=open,in_progress,hooked --json`. Default
watch rows are running mesh agents only; Bead/project/status are columns on
those agent rows. `--include-detached` is required to include Beads tasks that
do not have live terminals. Watch states are mechanical: `active`, `quiet`,
`detached`, and `orphan`. Do not add interpretive states such as "thinking" or
token/dollar budgets unless a future Codex CLI exposes a grounded metric
surface and the CUE contract is updated first.

**Wave dispatch.** `mesh wave dispatch REQUEST.json` consumes
`bd ready --parent <epic> --exclude-type epic --json`, launches at most the
request cap through the existing `spawn` adapter, and emits `#WaveStatus`.
`mesh wave status REQUEST.json` reports the same plan without launching.
Use `CODEX_MESH_BD_READY_FILE` or `--frontier` for offline fixture tests.
Wave dispatch is an invoked pass; it is not a daemon and does not own Beads
lifecycle state.

**Isolation.** `spawn` and `jump` accept `--isolation none|worktree` plus
`--worktree-base DIR`. Worktree mode derives the cwd from the address and
creates a detached git worktree for live launches; dry-run emits the derived
`workdir` and `codex_worktree` without creating it. Mutating `#WaveRequest`
records must use `isolation.mode=worktree`. codex-mesh never merges; serialized
integration belongs to Beads `bd merge-slot check/acquire/release`.

**Formula library.** Repo-local Beads formulas live in `.beads/formulas`.
`bd formula list` must show `cue-first-feature`, `review-wave`, `judge-panel`,
`loop-until-dry`, and `completeness-critic`. Each formula JSON vets against
`#Formula`; each pattern must support `bd mol wisp create <formula> --dry-run`.
These formulas are Beads workflow templates and may carry mesh `goal` metadata,
but codex-mesh does not schedule them itself.

**Orchestration default** (`#OrchestrationDefault`). Substantive work —
multi-step, mutating, or coverage-shaped — defaults to formula-driven
orchestration: pour a Beads formula, freeze and red-check goal predicates,
dispatch bounded role waves, close each task on a green predicate plus a
`#ResultEnvelope`, then run `loop-until-dry` and `completeness-critic` before
closeout. Solo execution requires a named exception (conversational reply,
single-read lookup, trivial mechanical edit, emergency transport recovery).
The posture is a contract record with valid and adversarial fixtures; the
skill and `mesh --help` teach the same discipline.

**Substrate boundary** (`#SubstrateBoundary`). Beads owns everything durable:
task graph, assignment, handoff context, cross-repo routing, merge
serialization. codex-mesh owns only the live terminal transport: launch,
address resolution, prompt delivery, parent-window close. Secrets belong to
operator-owned control-plane plugins. `codex_task` is a Beads issue id —
durable handoff context goes in the Beads issue, never in kitty vars. Scripts
may only call the pinned, version-verified Beads primitives listed in
`#CurrentBeadsPrimitive` (currently v1.1.0); do not invent `bd` subcommands.

**Transcripts.** Every `spawn`/`jump` session records raw PTY output bytes via
`scripts/codex-mesh-record` (a Python pty proxy). `#TranscriptPolicy` pins the
guarantees: output bytes only, no stdin capture, no semantic filtering.
Transcript filenames are `<kitty-window-id>.ansi`, and that window id is the
session id. `CODEX_MESH_TRANSCRIPT_DIR` overrides the destination;
`CODEX_MESH_TRANSCRIPT_DISABLE=1` is for emergencies/tests only.

## Notes

- AGENTS.md and CLAUDE.md are independent files — mirror substantive edits
  across both.
