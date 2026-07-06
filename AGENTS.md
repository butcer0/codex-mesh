# AGENTS.md - codex-mesh

## Project Contract

`codex-mesh` is CUE-first. `model/contract.cue` owns the durable semantics for
Codex terminal-agent lifecycle commands, fixtures prove the contract fails
closed, and `./scripts/verify.sh` owns local trust.

`spawn` means create a new addressed Codex agent and keep the initiating agent
alive. `tell` means send a normal user prompt to exactly one resolved agent.
`jump` means hand off to a confirmed successor and then close the initiating
kitty window; it is not a synonym for spawn. `mesh status` means expose a
read-time join between live terminal agents and one Beads status snapshot; it is
not a scheduler or durability layer. `mesh wave dispatch` is an invoked bounded
pass over Beads-ready children; it is not a daemon and does not own lifecycle
state. `mesh watch` renders the same live seam for humans or emits CUE-shaped
snapshots for tools; it must not infer agent intent or account for token spend.

## Orchestration Default

- Substantive work — multi-step, mutating, or coverage-shaped — defaults to
  formula-driven orchestration per `#OrchestrationDefault`. Solo execution
  requires a named exception: conversational reply, single-read lookup,
  trivial mechanical edit, or emergency transport recovery.
- The loop: pour a Beads formula, red-check frozen goal predicates before
  work, dispatch bounded role waves, close each task on a green predicate
  plus `#ResultEnvelope`, then run `loop-until-dry` and `completeness-critic`
  before closeout.
- Roles are contract-typed: implementation → `#ImplementationResult`,
  reviewer → `#ReviewFindings`, judge/probe → `#Verdict`. Prose-only results
  fail closed.

## Start Of Work

- Run `bd prime`.
- Run `bd ready` and inspect the selected bead with `bd show <id>`.
- Claim or update the bead before substantial work.
- Read `README.md` and the relevant `model/*.cue` files.

## Mutation Loop

- Update Beads first for meaningful work.
- Put command semantics and fail-closed invariants in `model/contract.cue`.
- Add valid and adversarial fixtures under `model/fixtures/`.
- Keep shell scripts as thin transport adapters over the CUE contract.
- Run `./scripts/verify.sh` before closeout.

## Local Commands

- `make install` links `spawn`, `tell`, `jump`, and `mesh` from
  `${PREFIX:-$HOME/.local}/bin` to `scripts/`.
- `make install` also links `skills/codex-mesh` into
  `${CODEX_HOME:-$HOME/.codex}/skills` so agents can discover the mesh workflow.
- Kitty user vars are the logical address layer; numeric kitty window ids are
  transport handles only.
- `mesh agents` and `mesh status` are exposure surfaces. Do not persist PIDs,
  idle state, or window liveness outside transcripts and Beads lifecycle edges.
- `mesh watch` is an exposure surface for operators and controller agents.
  It must run even when the caller cwd has no Beads DB. `--mesh-root DIR` and
  `CODEX_MESH_ROOT` scan direct child workspaces only. Default rows are running
  mesh agents only; `--include-detached` is required to include Beads tasks
  without live terminals. States are mechanical: `active`, `quiet`, `detached`,
  and `orphan`.
- `mesh wave dispatch` consumes `bd ready --parent <epic> --exclude-type epic
  --json`, launches at most the request cap, and emits `#WaveStatus`.
- Mutating waves require `isolation.mode=worktree`; codex-mesh may provision a
  worktree cwd, but merge serialization remains Beads `merge-slot` work.
- Beads formulas live in `.beads/formulas`; verify each formula JSON against
  `#Formula` and use `bd mol wisp create <formula> --dry-run` before trusting it.

# Beads Base Instructions

This project uses **bd** (beads) for issue tracking. Run `bd prime` for full workflow context.

> **Architecture in one line:** Issues live in a local Dolt database
> (`.beads/dolt/`); cross-machine sync uses `bd dolt push/pull` (a
> git-compatible protocol), stored under `refs/dolt/data` on your git
> remote — separate from `refs/heads/*` where your code lives.
> `.beads/issues.jsonl` is a passive export, not the wire protocol.
>
> See [SYNC_CONCEPTS.md](https://github.com/gastownhall/beads/blob/main/docs/SYNC_CONCEPTS.md)
> for the one-screen overview and anti-patterns (don't treat JSONL as the
> source of truth; don't `bd import` during normal operation; don't
> reach for third-party Dolt hosting before trying the default).

## Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work atomically
bd close <id>         # Complete work
bd dolt push          # Push beads data to remote
```

## Non-Interactive Shell Commands

**ALWAYS use non-interactive flags** with file operations to avoid hanging on confirmation prompts.

Shell commands like `cp`, `mv`, and `rm` may be aliased to include `-i` (interactive) mode on some systems, causing the agent to hang indefinitely waiting for y/n input.

**Use these forms instead:**
```bash
# Force overwrite without prompting
cp -f source dest           # NOT: cp source dest
mv -f source dest           # NOT: mv source dest
rm -f file                  # NOT: rm file

# For recursive operations
rm -rf directory            # NOT: rm -r directory
cp -rf source dest          # NOT: cp -r source dest
```

**Other commands that may prompt:**
- `scp` - use `-o BatchMode=yes` for non-interactive
- `ssh` - use `-o BatchMode=yes` to fail instead of prompting
- `apt-get` - use `-y` flag
- `brew` - use `HOMEBREW_NO_AUTO_UPDATE=1` env var

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
