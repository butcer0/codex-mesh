# Kitty capability catalog

Task: `mesh-wtx.2`
Date: 2026-07-06
Installed surface checked: `kitty 0.47.1 created by Kovid Goyal`

This catalog is about the Kitty rails that codex-mesh already depends on or
should deliberately avoid. It is not a general Kitty tutorial.

## Evidence

Local commands run against the installed binary:

- `kitty --version`
- `kitty --help`
- `kitty @ --help`
- `kitty @ launch --help`
- `kitty @ ls --help`
- `kitty @ send-text --help`
- `kitty @ set-user-vars --help`
- `kitty @ close-window --help`
- `kitty @ env --help`
- `kitty @ run --help`

Authoritative docs consulted where local help did not carry enough semantics:

- Remote control: <https://sw.kovidgoyal.net/kitty/remote-control/>
- Launch command: <https://sw.kovidgoyal.net/kitty/launch/>
- Sessions: <https://sw.kovidgoyal.net/kitty/sessions/>
- Configuration, especially `allow_remote_control`, `listen_on`, `remote_control_password`, and `watcher`: <https://sw.kovidgoyal.net/kitty/conf/>
- Remote control protocol: <https://sw.kovidgoyal.net/kitty/rc_protocol/>

## Current codex-mesh usage

codex-mesh is already on the right rail: it treats Kitty as a live transport,
not durable task state.

- `spawn` and `jump` launch Codex agents with `kitty @ [--to SOCKET] launch
  --type=os-window --hold --title ... --cwd ...`, then attach `codex_addr`,
  `codex_role`, `codex_parent`, and `codex_task` as Kitty user variables.
- Launched agents also receive process environment such as `CODEX_ADDR`,
  `CODEX_ROLE`, `CODEX_PARENT`, `CODEX_TASK`, `CODEX_MESH_ROOT`,
  `CODEX_MESH_TRANSCRIPT_DIR`, and, when relevant, the resolved
  `KITTY_LISTEN_ON`.
- `tell` resolves exactly one live window first, then sends a bracketed-paste
  prompt with `kitty @ [--to SOCKET] send-text --match id:<window-id> --stdin`
  and a separate carriage return.
- `jump` closes the initiating window with `kitty @ close-window --self` only
  after the successor is confirmed.
- `mesh agents`, `mesh status`, and `mesh watch` read `kitty @ [--to SOCKET]
  ls` and join that live tree with transcript metadata and Beads state.
- `codex-mesh-record` can add `codex_session` and `codex_transcript` after the
  PTY recorder starts via `kitty @ set-user-vars --match id:<session-id> ...`.

## Capability inventory

| Capability | Local / doc evidence | codex-mesh decision |
| --- | --- | --- |
| Remote control root | `kitty @ --help` says remote control requires `allow_remote_control`; official docs say it can open, send input to, close, and read windows. | Keep Kitty remote control as the substrate, but model it as a powerful live control plane. Do not treat it as ambient-safe IPC. |
| Socket targeting | `kitty --help` exposes `--listen-on`; `kitty @ --help` exposes global `--to`; official docs say `--to` targets the `--listen-on` or `listen_on` address, then falls back to `KITTY_LISTEN_ON` and finally the controlling terminal. | Keep `mesh context bind/show/resolve` as the deterministic socket resolver. Avoid scanning `/tmp/kitty-*`; bind an explicit mesh root to one socket. |
| Remote-control enablement | Official config docs say `listen_on` is ignored unless `allow_remote_control` is `yes`, `socket`, or `socket-only`. | Adoption proposal: operator examples should start Kitty with explicit enablement, preferably `kitty -o allow_remote_control=socket-only --listen-on unix:@mesh-lab ...` for local mesh work. |
| Fine-grained authorization | Official docs expose `remote_control_password` and per-window `--remote-control-password`; password mode can restrict actions and can delegate checks to Python. | Keep as an operator hardening rail. Public codex-mesh should document compatible use, but not own passwords, secret refs, or private policy. |
| JSON live tree | `kitty @ ls --help` says output is a JSON OS-window/tab/window tree with ids, titles, cwd, PID, command line, environment, and `is_self` when applicable. | Keep as the only live discovery source. Parse once per exposure read; do not persist PIDs, ids, cwd, or liveness. |
| User variables | `kitty @ launch --help` exposes `--var`; `kitty @ set-user-vars --help` sets, prints, and unsets user vars and supports `var:` matching. | Keep user vars as the logical address layer. Continue resolving to exactly one window before delivery; send by numeric id only after that resolution. |
| Send prompt text | `kitty @ send-text --help` supports `--match`, `--stdin`, and bracketed paste, but also says errors are not reported and the command always succeeds even when no text was sent. | Keep the preflight exact-one resolver. Never use `send-text` exit status as proof of delivery. Avoid `--all` for prompts. |
| Launch placement | `kitty @ launch --help` supports `window`, `tab`, `os-window`, overlays, background, cwd, env, vars, title, and focus control. Official launch docs match this and explain `--add-to-session`. | Keep `--type=os-window` for addressed agents. `tab` can be a future operator layout mode, but it must not change addressing or close semantics. |
| Working directory | `kitty @ launch --help` supports explicit `--cwd` and special values such as `current`, `last_reported`, `oldest`, and `root`. | Keep explicit worktree cwd for agents. Avoid `current` or shell-integration-derived cwd for mutating task placement. |
| Per-window environment | `kitty @ launch --help` supports repeated `--env`; `kitty @ env --help` changes environment for newly launched windows in a running instance. | Keep per-launch `--env` for agent metadata. Avoid global `kitty @ env` for codex-mesh state because it mutates future-window ambient state. |
| Parent close | `kitty @ close-window --help` supports `--self`, `--match`, `--ignore-no-match`, and `--no-response`. | Keep `jump` limited to `close-window --self` after successor proof. Avoid `--no-response` and avoid match-based parent close for handoff semantics. |
| Sessions | Official session docs define text files that create windows, tabs, layouts, working directories, and programs; `kitty --session` loads them; `launch --add-to-session` can attach a new window/tab to a session temporarily. | Adopt only as optional human layout scaffolding. Do not use sessions as task durability, scheduling, or resume truth. |
| Layouts | `kitty @ launch --help` exposes `--location` including split placements; remote control includes `goto-layout` and enabled-layout commands. | Potential future operator ergonomics rail: expose a layout preference without changing task semantics. Do not encode layout as lifecycle state. |
| Watchers | `kitty @ launch --help` and config docs expose Python watchers for launched-window events, plus global `watcher` config. | Reject as codex-mesh lifecycle authority. They are useful for operator-local decoration or diagnostics, but hidden Python callbacks would obscure the Beads/Kitty boundary. |
| Host command execution | `kitty @ run --help` executes a program on the computer where Kitty is running and returns its output; it says `launch --type=background` is the non-waiting alternative. | Reject for normal task execution. Codex and Beads should run commands in the selected workspace; `@ run` is at most a transport diagnostic or emergency recovery tool. |
| Raw protocol | Official protocol docs define JSON commands over an escape sequence and note protocol versioning and async/streaming request shapes. | Avoid implementing a second client while `kitty @` is installed. Use protocol docs only to explain trust boundaries or diagnose `kitty @` behavior. |

## Adopt now

1. Keep the explicit `listen_on` binding model.
2. Keep Kitty user vars as the logical live-address metadata.
3. Keep `kitty @ ls` as a live read, then join with Beads at read time.
4. Keep exact-one resolution before `send-text`, because `send-text` success is
   not delivery proof.
5. Update operator-facing examples in a follow-up to show
   `-o allow_remote_control=socket-only` beside `--listen-on`.

## Reject or constrain

1. Do not store Kitty window ids, PIDs, cwd, liveness, layouts, or sessions as
   durable task state.
2. Do not rely on `send-text` exit code for delivery.
3. Do not use `kitty @ env` to carry codex-mesh metadata.
4. Do not let Kitty watchers become schedulers, lifecycle hooks, or hidden task
   state.
5. Do not use `kitty @ run` as a Beads worker execution surface.
6. Do not use socket scanning as target discovery; context binding is the rail.

## Follow-up candidates for synthesis

- The getting-started command currently shows `--listen-on unix:@mesh-lab`; the
  catalog evidence says the example should also show remote control enablement.
- A small fixture or doc assertion could freeze the invariant that socket
  binding stores only `mesh_root` and `kitty_listen_on`.
- A future optional layout setting can choose `os-window` versus `tab`, but only
  after the CUE contract states that placement is not lifecycle state.
