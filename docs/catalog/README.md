# Capability Catalog Index

This directory is the accepted source set for the `mesh-wtx` capability
catalog. The deepen beads should cite all three catalogs together:

- [Beads capability catalog](beads.md): durable task graph, readiness, gates,
  molecules, formulas, swarms, merge slots, worktrees, sync, and integrations.
- [Kitty capability catalog](kitty.md): live terminal transport, remote-control
  socket targeting, user variables, launch placement, exact-one prompt
  delivery, and surfaces rejected as lifecycle state.
- [Codex capability catalog](codex.md): CLI launch, sandbox/approval/profile
  policy, AGENTS.md, skills, plugins, MCP, `codex exec`, `codex review`,
  native subagents, `/goal`, hooks, diagnostics, and auth boundaries.

## Consistency Checks

The catalogs are consistent on the core ownership boundary:

| Layer | Owns | Must not own |
| --- | --- | --- |
| Beads | Durable task DAGs, readiness, claims, comments, gates, swarms, formulas, molecule state, merge serialization, and optional cross-repo coordination. | Live terminal liveness, kitty window ids, Codex credentials, provider-specific remote defaults, or hidden mesh scheduler state. |
| Kitty | Live launch, live address metadata, socket targeting, prompt transport, parent-window close, and operator layout. | Durable task lifecycle, task resume truth, scheduling, secret policy, hidden watchers as lifecycle hooks, or host command execution as normal worker execution. |
| Codex | Model execution, instructions, AGENTS.md loading, skills, profiles, sandboxing, MCP/tool policy, auth, diagnostics, and optional noninteractive/review modes. | Beads task state, kitty address truth, mesh lifecycle storage, raw MCP inventory persistence, credentials, or provider routing in public project config. |

The current adoption proposals also agree:

- Use Beads frontiers and graph primitives before adding mesh-local graph
  walkers: `ready`, `ready --claim`, `ready --gated`, `swarm`, `gate`,
  `merge-slot`, `mol`, `formula`, `query`, `count`, and structured comments
  are cataloged as Beads-owned rails.
- Keep Kitty as a live transport rail: explicit `listen_on` binding, user vars,
  exact-one resolution before `send-text`, and `kitty @ ls` joins are current
  or near-term rails; sessions and layouts remain operator ergonomics.
- Move Codex launch posture into a typed policy before widening worker launch
  flags: sandbox/approval/profile/model/add-dir/search choices belong in CUE,
  and `--yolo` should be an explicit exceptional mode rather than a default.
- Keep result evidence durable in Beads comments and predicates. `/goal` is
  thread-local ergonomics; `mesh goal check` plus a `#ResultEnvelope` is the
  durable close surface.

No existing catalog file needed a consistency edit for this synthesis pass. The
remaining items in the catalogs are adoption candidates or deliberately rejected
surfaces, not catalog completeness gaps.

## Named Non-Adoption Reasons

| Surface | Reason not to adopt as a mesh primitive now |
| --- | --- |
| Beads JSONL export/import as runtime truth | Export is migration/viewer data, while Dolt-backed Beads state is the wire and durability layer. |
| Beads provider integrations and Dolt remote management | Provider tokens, remotes, and infrastructure are operator configuration, not public codex-mesh semantics. |
| Beads low-level admin/maintenance commands | They are explicit maintenance actions and need separate red/green predicates plus operator authorization. |
| Kitty socket scanning | Deterministic context binding is the rail; scanning ambient sockets makes target selection implicit. |
| Kitty `send-text` exit status as delivery proof | Kitty documents that `send-text` can succeed without delivery, so mesh must preflight exact-one resolution. |
| Kitty `env`, sessions, layouts, and watchers as lifecycle state | They are ambient or hidden operator surfaces; Beads remains the durable lifecycle owner. |
| Kitty `@ run` as normal worker execution | Worker commands should run in the selected Codex/Beads workspace, not through Kitty host execution. |
| Raw Kitty remote-control protocol client | The installed `kitty @` CLI already provides the public surface; a second client would add protocol drift. |
| Codex `--yolo` as default launch posture | It bypasses the installed sandbox/approval rails and should require explicit policy plus isolation evidence. |
| Codex plugins as public-core runtime dependency | Plugins may package distribution later, but core mesh currently depends on scripts plus the linked skill. |
| Raw Codex MCP inventory persistence | Local MCP command args can contain sensitive token-like values; only redacted health belongs in mesh evidence. |
| Codex native subagents as mesh lifecycle | Native subagents are useful inside one worker, but cross-agent durability stays in Beads tasks, envelopes, transcripts, and kitty addresses. |
| Codex remote/cloud/app-server surfaces as current transport replacements | They are a separate backend design, not a small extension of the current Kitty-backed contract. |
| Codex auth/login management | Codex owns credentials and login state; mesh can check health but must not store or print credentials. |

## Deepen Citation Matrix

Each downstream deepen bead should cite this index plus the three source
catalogs. The matrix below names the starting anchors for each bead.

| Deepen bead | Beads anchor | Kitty anchor | Codex anchor |
| --- | --- | --- | --- |
| `mesh-mol-49n` dispatch | Readiness frontier, `ready --claim`, `ready --gated`, structured comments, and wave frontier ownership in [beads.md](beads.md). | Launch placement, working directory, user variables, and exact-one `send-text` preflight in [kitty.md](kitty.md). | Launch policy, sandbox/approval profiles, `/goal`, and `codex exec` result-shaping in [codex.md](codex.md). |
| `mesh-mol-d0w` composition | Molecules, formulas, swarms, gates, `mol ready`, `mol progress/current`, and dependency graph commands in [beads.md](beads.md). | Sessions/layouts as optional human scaffolding, not composition durability, in [kitty.md](kitty.md). | AGENTS.md, skills, `/goal`, result envelopes, and reviewer/judge surfaces in [codex.md](codex.md). |
| `mesh-mol-4yl` reclaim | Claims, assignment, human decisions, gates, timers, stale/orphans, and worktree commands in [beads.md](beads.md). | Parent close, exact-one address resolution, no watcher scheduler, and no ambient `kitty @ env` state in [kitty.md](kitty.md). | Sandbox/approval policy, profiles, diagnostics, and rejection of default full bypass in [codex.md](codex.md). |
| `mesh-mol-0ph` workspace identity | Repo hydration, worktrees, config, Beads workspace commands, and export-vs-sync distinction in [beads.md](beads.md). | Context binding, socket targeting, user vars, JSON live tree, and direct-child watch boundary in [kitty.md](kitty.md). | AGENTS.md hierarchy, project config, skills, MCP redaction, and diagnostics in [codex.md](codex.md). |
| `mesh-mol-a4x` federation | `repo`, `federation`, `ship`, Dolt sync boundaries, swarms, gates, and provider integration limits in [beads.md](beads.md). | Bound mesh-root socket targeting and live-only multi-window discovery in [kitty.md](kitty.md). | Native subagent boundary, remote/cloud backend deferral, MCP policy, and auth ownership in [codex.md](codex.md). |
| `mesh-mol-4aa` cookbooks | Formula library, `mol` workflow surfaces, comments/envelopes, graph commands, and operator closeout evidence in [beads.md](beads.md). | Getting-started `listen_on` plus remote-control enablement, exact-one `tell`, and jump close semantics in [kitty.md](kitty.md). | AGENTS.md, skills, plugins as optional packaging, `codex exec`, `codex review`, hooks/rules, and diagnostics in [codex.md](codex.md). |

## Completeness Verdict

The accepted catalogs cover the surfaces named by the parent: installed Beads
command groups and formula rails, Kitty remote control/session/config/protocol
rails, and Codex CLI/context/config/sandbox/skill/MCP/plugin rails. The
remaining gaps are implementation choices to deepen under the child beads above,
not missing catalog sweeps.
