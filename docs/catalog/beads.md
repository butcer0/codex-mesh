# Beads Capability Catalog

Version stamp: installed `bd version 1.1.0 (8e4e59d39: HEAD@8e4e59d39f34)`, surveyed on 2026-07-06 from `/home/galeavenworth/lab/codex-mesh` with `bd -C /home/galeavenworth/lab/codex-mesh ...`.

Grounding commands:

- `bd -C /home/galeavenworth/lab/codex-mesh --help`
- `bd -C /home/galeavenworth/lab/codex-mesh version`
- `bd -C /home/galeavenworth/lab/codex-mesh ready --help`
- `bd -C /home/galeavenworth/lab/codex-mesh create --help`
- `bd -C /home/galeavenworth/lab/codex-mesh update --help`
- `bd -C /home/galeavenworth/lab/codex-mesh show --help`
- `bd -C /home/galeavenworth/lab/codex-mesh list --help`
- `bd -C /home/galeavenworth/lab/codex-mesh query --help`
- `bd -C /home/galeavenworth/lab/codex-mesh comments --help`
- `bd -C /home/galeavenworth/lab/codex-mesh dep --help`
- `bd -C /home/galeavenworth/lab/codex-mesh epic --help`
- `bd -C /home/galeavenworth/lab/codex-mesh swarm --help`
- `bd -C /home/galeavenworth/lab/codex-mesh gate --help`
- `bd -C /home/galeavenworth/lab/codex-mesh merge-slot --help`
- `bd -C /home/galeavenworth/lab/codex-mesh formula --help`
- `bd -C /home/galeavenworth/lab/codex-mesh formula list`
- `bd -C /home/galeavenworth/lab/codex-mesh mol --help`
- `bd -C /home/galeavenworth/lab/codex-mesh repo --help`
- `bd -C /home/galeavenworth/lab/codex-mesh worktree --help`
- `bd -C /home/galeavenworth/lab/codex-mesh dolt --help`
- `bd -C /home/galeavenworth/lab/codex-mesh config --help`
- `bd -C /home/galeavenworth/lab/codex-mesh doctor --help`
- `bd -C /home/galeavenworth/lab/codex-mesh preflight --help`
- `bd -C /home/galeavenworth/lab/codex-mesh export --help`
- `bd -C /home/galeavenworth/lab/codex-mesh import --help`
- `bd -C /home/galeavenworth/lab/codex-mesh backup --help`
- `bd -C /home/galeavenworth/lab/codex-mesh github --help`
- `bd -C /home/galeavenworth/lab/codex-mesh gitlab --help`
- `bd -C /home/galeavenworth/lab/codex-mesh jira --help`
- `bd -C /home/galeavenworth/lab/codex-mesh linear --help`
- `bd -C /home/galeavenworth/lab/codex-mesh notion --help`
- `bd -C /home/galeavenworth/lab/codex-mesh ado --help`
- `bd -C /home/galeavenworth/lab/codex-mesh federation --help`
- `bd -C /home/galeavenworth/lab/codex-mesh ship --help`
- `rg -n "\\bbd(\\s|-C|\\b)|#CurrentBeadsPrimitive|Beads" scripts model README.md docs .beads/formulas`

The installed binary help was sufficient for this pass; no external Beads docs were needed to classify the current local surface.

## Top-Level Surface

`bd --help` exposes these major groups:

- Working with issues: `assign`, `children`, `close`, `comment`, `comments`, `create`, `create-form`, `delete`, `edit`, `gate`, `label`, `link`, `list`, `merge-slot`, `note`, `priority`, `promote`, `q`, `query`, `reopen`, `search`, `set-state`, `show`, `state`, `tag`, `todo`, `update`.
- Views and reports: `count`, `diff`, `find-duplicates`, `history`, `lint`, `stale`, `status`, `statuses`, `types`.
- Dependencies and structure: `dep`, `duplicate`, `duplicates`, `epic`, `graph`, `supersede`, `swarm`.
- Sync and data: `backup`, `branch`, `export`, `federation`, `import`, `restore`, `vc`.
- Setup and configuration: `bootstrap`, `config`, `context`, `dolt`, `forget`, `hooks`, `human`, `info`, `init`, `kv`, `memories`, `onboard`, `prime`, `quickstart`, `recall`, `remember`, `setup`, `where`.
- Maintenance: `admin`, `batch`, `compact`, `doctor`, `flatten`, `gc`, `migrate`, `ping`, `preflight`, `prune`, `purge`, `recompute-blocked`, `rename-prefix`, `rules`, `sql`, `upgrade`, `worktree`.
- Integrations and advanced: `ado`, `audit`, `completion`, `cook`, `defer`, `formula`, `github`, `gitlab`, `help`, `init-safety`, `jira`, `linear`, `mail`, `metrics`, `mol`, `notion`, `orphans`, `ready`, `rename`, `ship`, `undefer`, `version`.

## Current Mesh Usage

`codex-mesh` currently uses Beads as the durable task layer and keeps mesh state live-only. The checked surfaces are:

- `model/contract.cue`: `#CurrentBeadsPrimitive` allows `ready`, `show`, `update --claim`, `assign`, `comment`, `comments`, `note`, `list --status=open,in_progress,hooked --json`, `bd -C <workspace> list --status=open,in_progress,hooked --json`, `swarm`, `gate`, `merge-slot`, `repo`, `mol`, and `formula list`.
- `scripts/codex-mesh-workspaces`: shells out to `bd -C <workspace> list --status=open,in_progress,hooked --json` for workspace snapshots.
- `scripts/codex-mesh-lib.sh`, `scripts/codex-mesh-status`, and `scripts/codex-mesh-watch`: use `bd list --status=open,in_progress,hooked --json` for the Beads side of the live join.
- `scripts/codex-mesh-wave`: uses `bd ready --parent <epic> --exclude-type epic --json` as the frontier query.
- `scripts/codex-mesh-init`: shells out to `bd init` and optionally configures a remote supplied by the operator.
- `scripts/verify.sh`: asserts formula visibility with `bd formula list`, dry-runs `bd mol wisp create <formula> --dry-run`, and checks `bd mol pour cue-first-feature --dry-run`.
- README and fixtures explicitly reject stale command assumptions such as `bd routes`, `bd hook`, `bd agents`, `bd pin`, and `bd reservations`.

## Capability Map

| Capability | Installed truth | Mesh status | Adoption proposal |
| --- | --- | --- | --- |
| Issue creation and mutation | `create` has structured fields for parent, labels, metadata, repo, skills, spec id, validation, graph import, body/design files, explicit id, and event beads. `update` has atomic `--claim`, status/assignee/metadata/parent updates, stdin/file bodies, and label mutation. | Used narrowly. Mesh and formulas rely on external Beads issue setup and `update --claim` appears in the contract, but runtime wave dispatch does not claim. | For mutating waves, prefer a Beads-owned claim step (`ready --claim` or `update --claim`) before launch instead of treating a read frontier as exclusive. Keep issue creation in formulas or PM coordination, not hidden mesh runtime state. |
| Readiness frontier | `ready` is blocker-aware, excludes active/deferred/hooked work, supports `--parent`, `--exclude-type`, `--json`, `--claim`, `--gated`, `--mol`, filters, and `--explain`. `list --ready` has the same ready-work semantics. | Used. `mesh wave dispatch` consumes `bd ready --parent <epic> --exclude-type epic --json`; `mesh watch` and `mesh status` use `list` instead. | Add contract fixtures for `ready --claim` and `ready --gated` before adopting them. `--gated` is the installed primitive for molecule gate-resume dispatch; mesh should expose it only as a Beads frontier, not as a scheduler. |
| Issue detail and comments | `show --json --include-comments` can stream comment bodies; `comments <id> --json` lists comments; `comment` is shorthand for `comments add`. | Partly used. The current goal predicate checks result envelopes by grepping text output from `bd comments`, and the contract already includes `bd comment` and `bd comments`. | Treat `comments --json` or `show --json --include-comments` as the close-predicate surface for result envelopes so tools parse structured Beads data instead of terminal formatting. |
| Notes, labels, priorities, statuses, and types | `note`, `assign`, `tag`, and `priority` are shorthands over `update`; `label` has add/remove/list/list-all/propagate; `statuses` and `types` expose configured vocabulary. | Used narrowly. Mesh stores live identity in kitty vars and durable handoff in Beads, but it does not yet depend on typed state labels or custom status categories. | Keep shorthands available for operator ergonomics. If mesh adopts custom states, require CUE fixtures for `statuses --json` and forbid interpreting arbitrary labels as lifecycle state without a contract. |
| Query and search | `list` has extensive filters and JSON; `query` supports boolean expressions over fields; `search` is title/ID oriented with filters; `count` groups by status/priority/type/assignee/label. | Underused. Mesh mostly uses fixed `list --status=open,in_progress,hooked --json` calls and Beads-ready frontiers. | Use `query` for operator reports and completeness critics where multiple filters would otherwise become shell pipelines. Keep `mesh watch` on one fixed status query unless a CUE-shaped request model is added. |
| Dependency graph | `dep` has add/remove/list/tree/cycles/relate/unrelate; `graph`, `children`, `duplicate`, `duplicates`, `supersede`, and `epic status/close-eligible` are installed. | Used conceptually. README and formulas treat Beads as the DAG owner; mesh does not inspect graph shape beyond `ready`. | Push dependency reasoning into Beads commands. Use `dep cycles`, `children --json`, and `epic status` for PM/synthesis tasks before adding mesh-local graph walkers. |
| Swarms | `swarm create/list/status/validate` treats an epic and children as a structured parallel DAG. | Contracted but not deeply used. `#CurrentBeadsPrimitive` allows `bd swarm`, `swarm validate`, and `swarm status`; runtime scripts do not call them. | Before expanding `mesh wave`, validate epic shape with `swarm validate <epic> --json` and report `swarm status <epic> --json` in PM dashboards. Do not duplicate swarm status in mesh storage. |
| Gates | `gate` supports human, timer, GitHub run, GitHub PR, and bead gates with `create`, `check`, `resolve`, `show`, `list`, `discover`, and `add-waiter`. | Contracted, not fully adopted. CUE recognizes `bd gate` and `bd gate check --dry-run`; README says gates are Beads-owned. | Use Beads gates for async waits and human decisions. Mesh should only expose gate readiness or pass through a dry-run check in predicates. |
| Merge serialization | `merge-slot` has `create`, `check`, `acquire`, and `release`. | Contracted. README says mutating main-checkout work needs Beads merge-slot coordination. | Route all main-checkout merge/integration workers through `merge-slot acquire --holder <holder>` and `release --holder <holder>` fixtures. Worktree workers should not merge branches themselves. |
| Molecules and formulas | `formula list/show/convert` finds workflow formulas from project, checkout, user, and shared roots. `mol` supports `pour`, `wisp`, `bond`, `ready`, `progress`, `current`, `show`, `squash`, `burn`, `distill`, `stale`, `seed`, and `last-activity`. Local `formula list` found `completeness-critic`, `cue-first-feature`, `judge-panel`, `loop-until-dry`, and `review-wave`. | Used. README and verify cover formulas and dry-runs; orchestration default is formula-driven. `mol ready`, `mol progress`, and `mol current` are not used by mesh yet. | Adopt `mol ready` as the Beads-owned gate-resume frontier after a CUE request shape exists. Use `mol progress/current` for PM synthesis instead of inventing mesh progress state. |
| Batch writes | `batch` runs a narrow grammar of write operations in one transaction: close, update status/priority/title/assignee, create, dep add/remove. | Unused. Current scripts call individual commands when they mutate. | Use `batch` only for high-volume graph creation or cleanup formulas after validating the grammar. Do not force it into ordinary single-issue claim/comment/close paths. |
| Worktrees | `worktree create/info/list/remove` manages git worktrees and shares the same Beads database through git common-dir discovery. | Underused. codex-mesh currently has its own worktree isolation contract and this task used an externally provisioned worktree with Beads operations routed to the main checkout. | Evaluate replacing or supplementing raw `git worktree add --detach <path> HEAD` with `bd worktree create/info` for worker placement, but only if deterministic path and cleanup semantics can be encoded in CUE. |
| Repo, federation, and shipped capabilities | `repo add/list/remove/sync` hydrates multiple Beads repos into one DB; `federation add-peer/list-peers/remove-peer/status/sync` syncs peer Dolt-backed databases; `ship` marks a closed export-labeled issue as providing a cross-project capability. | Partly used in the contract. `repo` is allowed, but `federation` and `ship` are not modeled. | For multi-project mesh roots, use `repo` and possibly `ship` as Beads-owned cross-project dependency primitives. Keep `federation` operator-configured until a public, provider-neutral contract exists. |
| Dolt sync and database control | `dolt` has server lifecycle, config, connection test, commit/push/pull, remotes, and cleanup. `vc` has commit/merge/status; `branch` lists or creates Dolt branches. | Boundary-owned by Beads/operator. README correctly says remotes are operator configuration, and mesh does not own Beads remote hosting. | Keep mesh from wrapping Dolt remotes or secrets. PM closeout may require explicit `bd dolt push/pull`, but runtime mesh commands should not silently sync Beads. |
| Export, import, backup, restore | `export` writes issue JSONL for migration/interoperability and excludes memories by default. Help explicitly says it is not a full backup. `import` upserts JSONL and can import memory records. `backup` is Dolt-native and preserves tables, branches, commit history, and working-set data. | Correctly treated as adjacent. README says `.beads/issues.jsonl` is passive export, not the wire protocol. | Keep JSONL out of runtime truth. Use `backup` for recovery policy and `dolt push/pull` for cross-machine sync; use export/import only for viewer/migration flows. |
| Configuration and hooks | `config` covers export/import settings, integrations, custom statuses, doctor suppressions, drift/apply/validate. `hooks` installs, lists, runs, and uninstalls git hooks. `kv` stores arbitrary key-value data. | Underused. Mesh install and doctor do not manage Beads config beyond prerequisite checks. | Keep operator config outside public mesh defaults. Use `config validate/show --json` as evidence when mesh init or doctor needs to explain Beads configuration without mutating it. |
| Doctor, preflight, lint, stale, orphans | `doctor` has health, perf, output, check-specific, deep, server, migration, and agent modes. `preflight --check --json`, `lint`, `stale`, and `orphans` are installed. | Mostly unused by mesh. `scripts/verify.sh` is the repo trust gate; Beads health is currently operator/manual. | Add optional PM closeout evidence that runs `bd doctor --check=conventions`, `bd preflight --check --json`, or `bd lint` when Beads graph health is relevant. Keep them advisory unless a CUE predicate requires them. |
| Human decisions | `human list/respond/dismiss/stats` manages human-needed beads. `gate` also has human gates. | Unused. Current mesh prompts ask the operator through chat or Beads comments rather than a formal human queue. | For orchestration-by-default, prefer `bd gate create --type=human` or `bd human` flows over chat-only blockers when a worker needs operator input. |
| Integrations | `github`, `gitlab`, `jira`, `linear`, `notion`, and `ado` have pull/push/status/sync surfaces; GitHub/GitLab also list repos/projects; Linear exposes team listing and mapping config. `mail` delegates to an external provider. | Not mesh-owned. Current public contract rejects provider-specific remotes and secrets in core mesh. | Keep integrations out of codex-mesh runtime contracts unless modeled as operator-provided Beads configuration. Mesh may report that integration commands exist, but must not require provider tokens or encode provider-specific defaults. |
| Administrative and low-level maintenance | `admin`, `compact`, `flatten`, `gc`, `migrate`, `prune`, `purge`, `recompute-blocked`, `rename-prefix`, `sql`, `upgrade`, and `rules` are installed. | Unused. They are outside normal mesh orchestration. | Do not call these from mesh automation except under an explicit maintenance bead with red/green predicates and operator authorization. |
| Agent memory | `remember`, `memories`, `recall`, and `forget` are installed and surfaced by `bd prime`. | Used by Beads workflow context, not mesh runtime. | Keep persistent project memory in Beads, not repo docs, when it is operational state. Catalogs like this remain durable source documentation, not memory updates. |

## Immediate Contract Deltas Worth Considering

These are not implementation tickets by themselves; they are contract candidates for the synthesis bead:

- Add `bd ready --claim` and `bd ready --gated` to the modeled primitive set after adversarial fixtures prove wave dispatch cannot double-dispatch or silently skip gated molecule resumes.
- Replace text-grep result-envelope checks with `bd comments --json` or `bd show --json --include-comments` predicates.
- Add a CUE distinction between Beads issue export (`bd export`) and durability/sync (`bd dolt push/pull`, `bd backup`) so future docs cannot treat JSONL as a wire protocol.
- Evaluate `bd worktree create/info/list/remove` against the current `#WorktreeCommand` before continuing to own raw git-worktree semantics in codex-mesh.
- Model `bd human` or human gate flows as the operator-decision primitive instead of ad hoc chat blockers.
- Consider `bd query` and `bd count` as PM/completeness-critic reporting surfaces, while keeping runtime watch/status on the already-contracted fixed JSON reads.

