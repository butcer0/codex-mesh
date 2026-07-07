# Codex capability catalog

Task: `mesh-wtx.3`
Local Codex surface: `codex-cli 0.142.5` on Linux, installed at
`/home/galeavenworth/.local/bin/codex`.

## Evidence

Local commands run:

- `codex --version`
- `codex --help`
- `codex exec --help`
- `codex review --help`
- `codex login --help`
- `codex mcp --help`
- `codex plugin --help`
- `codex features --help`
- `codex features list`
- `codex doctor --summary --ascii`
- `codex sandbox --help`
- `codex debug --help`
- `codex --dangerously-bypass-approvals-and-sandbox --version`
- `codex --yolo --version`
- `codex mcp list`
- `node /home/galeavenworth/.codex/skills/.system/openai-docs/scripts/fetch-codex-manual.mjs`

Authoritative docs used: the current official Codex manual fetched to
`/tmp/openai-docs-cache/codex-manual.md`, especially these sections:

- [CLI command reference](https://developers.openai.com/codex/cli/reference)
- [Codex CLI features](https://developers.openai.com/codex/cli/features)
- [Non-interactive mode](https://developers.openai.com/codex/noninteractive)
- [Custom instructions with AGENTS.md](https://developers.openai.com/codex/guides/agents-md)
- [Agent Skills](https://developers.openai.com/codex/skills)
- [Model Context Protocol](https://developers.openai.com/codex/mcp)
- [Sandbox](https://developers.openai.com/codex/concepts/sandboxing)
- [Advanced Configuration](https://developers.openai.com/codex/config-advanced)
- [Subagents](https://developers.openai.com/codex/concepts/subagents)
- [Plugins](https://developers.openai.com/codex/plugins)

`codex doctor --summary --ascii` reported a healthy local install, configured
auth, four enabled stdio MCP servers, restricted filesystem and network, and
approval policy `OnRequest`. `codex features list` reported native `goals`,
`hooks`, `plugins`, `apps`, `browser_use`, `computer_use`, `multi_agent`,
`unified_exec`, and `shell_tool` as enabled stable features in this environment.

Raw `codex mcp list` output is not copied here. In this local environment it
showed that server command arguments can contain sensitive token-like values
even when environment variables are redacted, so codex-mesh should treat raw MCP
inventory as sensitive unless it is explicitly scrubbed.

## Catalog

| Capability | Current codex-mesh use | Adopt / reject |
| --- | --- | --- |
| Interactive CLI launch | `spawn` and `jump` launch `codex` in a new kitty OS window, set kitty user vars such as `codex_addr`, `codex_role`, and `codex_task`, and optionally pass one initial prompt as argv text. | Keep kitty launch as the live terminal substrate. Add a typed launch policy before widening argv pass-through; the safe allow-list is `--model`, `--profile`, `--sandbox`, `--ask-for-approval`, `--search`, `--add-dir`, `--strict-config`, and typed `--config` keys. |
| `--dangerously-bypass-approvals-and-sandbox` / `--yolo` | `scripts/codex-mesh-lib.sh` currently launches children with `codex --yolo`. The installed binary accepts both the long flag and `--yolo`. | Treat this as a high-risk legacy default. Replace with an explicit CUE-backed launch mode: normal workers should use a sandbox/approval profile, and full bypass should require an externally isolated worktree plus an explicit policy reason. |
| Sandbox and approvals | codex-mesh does not configure child sandboxing beyond `--yolo`. The parent install is healthy under restricted fs/network and approval `OnRequest`. | Adopt Codex sandboxing instead of bypassing it by default. CUE should distinguish read-only catalog/review work, mutating worktree work, and exceptional full-access work. |
| Profiles and `config.toml` | No project Codex profile is used by the mesh launch scripts. | Adopt named profiles for repeatable worker classes. Keep provider/auth/telemetry keys in user or managed config, not public project config. |
| Project `.codex/config.toml` | Not used in this repo at catalog time. | Use only for trusted repo-local behavior that is safe to publish, such as default sandbox posture or optional hooks. Do not encode provider routing, tokens, operator telemetry, or machine-local notification commands. |
| AGENTS.md hierarchy | codex-mesh relies on repo guidance and the worker cwd. Codex docs say AGENTS files are loaded once per run from global scope plus project path, with nearer files later in the instruction chain. | Keep durable project rules in root `AGENTS.md` and any scoped override near the relevant subtree. Do not duplicate durable handoff context in prompt text when Beads owns it. |
| Skills | `make install` links `skills/codex-mesh` into `CODEX_HOME` so spawned agents can discover the mesh workflow. | Keep the codex-mesh skill as the reusable workflow surface. Add or maintain app metadata only when the skill needs UI/dependency declarations; keep task facts in Beads and predicates. |
| Plugins | Local Codex has plugin management, but codex-mesh core uses direct scripts plus a skill link. | Reject plugins as a runtime dependency for public core. Consider a plugin only as a distribution wrapper for the skill and optional MCP/app integrations. |
| MCP servers | Codex owns MCP configuration and tool exposure. codex-mesh currently does not manage MCP server config. | Do not persist raw MCP server args or env in mesh state. A future `mesh doctor` bridge may report redacted MCP health, but tool policy and credentials stay in Codex config. |
| `codex exec` | Unused by codex-mesh. | Adopt for non-interactive, no-kitty jobs such as scripted critics, summarizers, or CI-style checks. Use `--json` or `--output-schema` when a Beads result envelope needs machine-shaped evidence. |
| `codex review` and `/review` | Unused by codex-mesh. | Adopt as a possible reviewer-role backend for read-only Beads tasks after its output is normalized to `#ReviewFindings`. Do not let it close tasks directly. |
| Native subagents and `/agent` | Local feature flag `multi_agent` is stable and enabled, but codex-mesh uses visible kitty windows as addressed agents. Official docs say Codex subagents are explicitly requested and return summaries to the main thread. | Reject native subagents as the durable mesh lifecycle. They can be used inside one worker for read-heavy exploration, but Beads tasks, result envelopes, kitty addresses, and transcripts remain the cross-agent contract. |
| `/goal` | This task itself uses the Codex goal surface, while codex-mesh separately evaluates frozen `#GoalPredicate` JSON. | Use `/goal` as thread-local operator ergonomics only. Durable close criteria stay in `mesh goal check` plus Beads comments. |
| Hooks and rules | Codex has stable hooks and local execpolicy rules. codex-mesh does not depend on them. | Adopt hooks/rules only as optional local guardrails. They are not acceptance evidence unless the CUE predicate checks their effect directly. |
| Web search, browser, computer use, apps | The local install exposes these as Codex features, but codex-mesh public core does not assume connector access. | Keep these outside mesh lifecycle state. Workers may use them when explicitly needed and allowed, but result envelopes must record redacted evidence rather than connector state. |
| Remote app-server and cloud tasks | Official docs expose app-server, remote TUI, remote-control, and cloud surfaces; several are experimental or separate hosted workflows. | Reject as current transport replacements. Revisit as a separate CUE-first backend design only if codex-mesh needs a non-kitty transport. |
| Auth and login | Codex owns login; CLI supports status and stdin-based API key or access-token login. | codex-mesh must not manage, print, or store Codex credentials. It should depend on `codex doctor` or process exit codes for auth health. |
| Diagnostics | `codex doctor --summary --ascii` gives a concise health report; `codex features list` gives feature state. | Adopt these as human diagnostics and optional `mesh doctor` inputs. Machine use should prefer redacted JSON only after its schema is explicitly modeled. |

## Proposed CUE follow-up

The next contract work should add a `#CodexLaunchPolicy` or equivalent record
instead of adding ad hoc shell flags. It should constrain:

- launch mode: `interactive_kitty`, `noninteractive_exec`, or `review`
- sandbox mode and approval policy
- optional profile and model override
- allowed writable roots and `--add-dir` use
- web-search mode
- MCP inventory redaction policy
- full-access bypass justification
- result-envelope shape for noninteractive and reviewer runs

That keeps Codex-native power available while preserving the current project
boundary: Beads owns durable work state, codex-mesh owns live transport and
predicate evidence, and Codex owns model execution, sandboxing, skills, MCP,
plugins, auth, and local configuration.
