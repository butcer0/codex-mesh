#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

need() {
	command -v "$1" >/dev/null 2>&1 || {
		echo "verify-offline: missing required command: $1" >&2
		exit 1
	}
}

need bash
need cue
need jq
need python3
need git

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

OFFLINE_BIN="$TMPDIR/offline-bin"
mkdir -p "$OFFLINE_BIN"
cat >"$OFFLINE_BIN/bd" <<'SH'
#!/usr/bin/env bash
exit 0
SH
cat >"$OFFLINE_BIN/kitty" <<'SH'
#!/usr/bin/env bash
if [[ "${1:-}" == "@" && "${2:-}" == "ls" ]]; then
	printf '[]\n'
	exit 0
fi
exit 0
SH
cat >"$OFFLINE_BIN/codex" <<'SH'
#!/usr/bin/env bash
exit 0
SH
chmod +x "$OFFLINE_BIN/bd" "$OFFLINE_BIN/kitty" "$OFFLINE_BIN/codex"
PATH="$OFFLINE_BIN:$PATH"
for script in scripts/codex-mesh-lib.sh scripts/codex-mesh-doctor scripts/spawn scripts/tell scripts/jump scripts/mesh scripts/verify.sh scripts/verify-contract.sh scripts/verify-offline.sh scripts/verify-runtime.sh; do
	bash -n "$script"
done
python3 - skills/codex-mesh/SKILL.md <<'PY'
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
if "[TODO" in text:
    raise SystemExit("verify: skill contains TODO markers")
if not text.startswith("---\n"):
    raise SystemExit("verify: skill is missing YAML frontmatter")
try:
    _, frontmatter, body = text.split("---", 2)
except ValueError as exc:
    raise SystemExit("verify: malformed skill frontmatter") from exc
fields = {}
for line in frontmatter.strip().splitlines():
    if ":" not in line:
        raise SystemExit(f"verify: malformed skill frontmatter line: {line}")
    key, value = line.split(":", 1)
    fields[key.strip()] = value.strip()
if fields.get("name") != "codex-mesh":
    raise SystemExit("verify: skill name must be codex-mesh")
description = fields.get("description", "")
if len(description) < 80 or "Use when" not in description:
    raise SystemExit("verify: skill description must include concrete triggers")
if "make install" not in body or "mesh goal check" not in body:
    raise SystemExit("verify: skill body must cover install and goal checks")
PY
python3 - scripts/codex-mesh-record <<'PY'
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
compile(path.read_text(), str(path), "exec")
PY
python3 - scripts/codex-mesh-init <<'PY'
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
compile(path.read_text(), str(path), "exec")
PY
python3 - scripts/codex-mesh-agents <<'PY'
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
compile(path.read_text(), str(path), "exec")
PY
python3 - scripts/codex-mesh-status <<'PY'
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
compile(path.read_text(), str(path), "exec")
PY
python3 - scripts/codex-mesh-watch <<'PY'
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
compile(path.read_text(), str(path), "exec")
PY
python3 - scripts/codex-mesh-workspaces <<'PY'
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
compile(path.read_text(), str(path), "exec")
PY
python3 - scripts/codex-mesh-context <<'PY'
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
compile(path.read_text(), str(path), "exec")
PY
python3 - scripts/codex-mesh-goal <<'PY'
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
compile(path.read_text(), str(path), "exec")
PY
python3 - scripts/codex-mesh-wave <<'PY'
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
compile(path.read_text(), str(path), "exec")
PY
python3 - scripts/codex-mesh-workflow <<'PY'
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
compile(path.read_text(), str(path), "exec")
PY

scripts/spawn --help >/dev/null
scripts/tell --help >/dev/null
scripts/jump --help >/dev/null
scripts/mesh --help >/dev/null
scripts/mesh doctor --help >/dev/null
scripts/mesh init --help >/dev/null
scripts/mesh status --help >/dev/null
scripts/mesh watch --help >/dev/null
scripts/mesh context --help >/dev/null
scripts/mesh context bind --help >/dev/null
scripts/mesh context resolve --help >/dev/null
scripts/mesh workspaces --help >/dev/null
scripts/mesh cookbook --help >/dev/null
scripts/mesh cookbook render --help >/dev/null
scripts/mesh goal --help >/dev/null
scripts/mesh goal check --help >/dev/null
scripts/mesh wave --help >/dev/null
scripts/mesh wave dispatch --help >/dev/null
scripts/mesh wave status --help >/dev/null
scripts/mesh workflow --help >/dev/null
scripts/mesh workflow plan --help >/dev/null
scripts/mesh workflow run --help >/dev/null
scripts/mesh workflow status --help >/dev/null

CODEX_MESH_KITTY_LS_FILE=tests/kitty-ls-single.json scripts/tell --resolve-only codex-implementation-1 | grep -q '^window_id=7$'
if CODEX_MESH_KITTY_LS_FILE=tests/kitty-ls-empty.json scripts/tell --resolve-only codex-implementation-1 >/dev/null 2>&1; then
	echo "verify: tell unexpectedly resolved a missing agent" >&2
	exit 1
fi
if CODEX_MESH_KITTY_LS_FILE=tests/kitty-ls-duplicate.json scripts/tell --resolve-only codex-implementation-1 >/dev/null 2>&1; then
	echo "verify: tell unexpectedly resolved duplicate agents" >&2
	exit 1
fi

CODEX_MESH_SESSION_ID=99 CODEX_MESH_RECORD_SET_KITTY_VARS=0 scripts/codex-mesh-record "$TMPDIR/recordings" sh -c 'printf "hello stdout\n"; printf "hello stderr\n" >&2' >"$TMPDIR/record.out" 2>&1
recording="$(find "$TMPDIR/recordings" -maxdepth 1 -type f -name '*.ansi' -print)"
[[ -n "$recording" ]] || {
	echo "verify: recorder did not create a transcript" >&2
	exit 1
}
grep -q 'hello stdout' "$recording"
grep -q 'hello stderr' "$recording"
cmp "$TMPDIR/record.out" "$recording" >/dev/null
mkdir -p "$TMPDIR/transcripts"
printf 'recent output\n' >"$TMPDIR/transcripts/7.ansi"

scripts/mesh doctor --json >"$TMPDIR/install-doctor.json"
cue vet "$TMPDIR/install-doctor.json" model/contract.cue -d '#InstallDoctor'
jq -e '
	.record_type == "install_doctor"
	and .scope == "codex-mesh"
	and .dependency_policy == "prerequisites-explicit"
	and .auto_install == false
	and .install_command == "make install"
	and .doctor_command == "mesh doctor"
	and ([.dependencies[].name] | index("kitty"))
	and ([.dependencies[].name] | index("bd"))
	and ([.dependencies[].name] | index("codex"))
	and ([.dependencies[].name] | index("cue"))
	and ([.dependencies[] | select(.required_for == "runtime").name] | index("git"))
	and ([.dependencies[] | select(.required_for == "verification").name] == ["cue"])
' "$TMPDIR/install-doctor.json" >/dev/null
scripts/mesh doctor | grep -q 'prerequisites-explicit'

scripts/mesh init --dry-run --json --prefix lab --remote http://example.invalid:50051/example/lab "$TMPDIR/mesh-init" >"$TMPDIR/mesh-init.json"
cue vet "$TMPDIR/mesh-init.json" model/contract.cue -d '#MeshInit'
jq -e '
	.record_type == "mesh_init"
	and .mesh_root == $root
	and .prefix == "lab"
	and .dry_run == true
	and .remote_source == "operator-config"
	and .remote_url == "http://example.invalid:50051/example/lab"
	and ([.commands[].status] | unique) == ["planned"]
	and (.commands[0].argv == ["mkdir", "-p", $root])
	and (.commands[1].argv == ["git", "init", $root])
	and (.commands[2].cwd == $root)
	and (.commands[2].argv[-2:] == ["--remote", "http://example.invalid:50051/example/lab"])
' --arg root "$TMPDIR/mesh-init" "$TMPDIR/mesh-init.json" >/dev/null

CODEX_MESH_KITTY_LS_FILE=tests/kitty-ls-single.json CODEX_MESH_TRANSCRIPT_DIR="$TMPDIR/transcripts" CODEX_MESH_NOW="$(date +%s)" scripts/mesh agents --json --idle-threshold 999999 | jq -e --arg transcript_dir "$TMPDIR/transcripts" '
	(.agents | length) == 1
	and .agents[0].session_id == "7"
	and .agents[0].window_id == 7
	and .agents[0].address == "codex-implementation-1"
	and .agents[0].transcript_path == $transcript_dir + "/7.ansi"
	and .agents[0].transcript_exists == true
	and .agents[0].working_state == "active"
' >/dev/null
CODEX_MESH_KITTY_LS_FILE=tests/kitty-ls-invalid-task.json CODEX_MESH_TRANSCRIPT_DIR="$TMPDIR/transcripts" scripts/mesh agents --json | jq -e '
	(.agents | length) == 1
	and .agents[0].address == "codex-legacy-1"
	and (.agents[0] | has("task") | not)
' >/dev/null

CODEX_MESH_KITTY_LS_FILE=tests/kitty-ls-status.json CODEX_MESH_BD_LIST_FILE=tests/bd-list-status.json CODEX_MESH_TRANSCRIPT_DIR="$TMPDIR/transcripts" CODEX_MESH_NOW="$(date +%s)" scripts/mesh status --json --idle-threshold 999999 >"$TMPDIR/status.json"
cue vet "$TMPDIR/status.json" model/contract.cue -d '#MeshBeadsJoin'
jq -e '
	.beads_command == "bd list --status=open,in_progress,hooked --json"
	and ([.records[].classification] | sort) == ["live_agent_with_task", "live_agent_without_task", "task_without_live_session", "task_without_live_session"]
	and (.records[] | select(.classification == "live_agent_with_task").task_id) == "mesh-1az.5"
	and (.records[] | select(.classification == "live_agent_without_task").agent.address) == "codex-reviewer-1"
	and (.records[] | select(.task_id == "mesh-open").resume_signal) == false
	and (.records[] | select(.task_id == "mesh-hooked").resume_signal) == true
' "$TMPDIR/status.json" >/dev/null
CODEX_MESH_KITTY_LS_FILE=tests/kitty-ls-status.json CODEX_MESH_BD_LIST_FILE=tests/bd-list-status.json CODEX_MESH_TRANSCRIPT_DIR="$TMPDIR/transcripts" CODEX_MESH_NOW="$(date +%s)" scripts/mesh status --idle-threshold 999999 | grep -q 'live_agent_with_task'

CODEX_MESH_KITTY_LS_FILE=tests/kitty-ls-watch.json CODEX_MESH_WORKSPACES_FILE=tests/workspaces-watch.json CODEX_MESH_TRANSCRIPT_DIR="$TMPDIR/transcripts" CODEX_MESH_NOW="$(date +%s)" scripts/mesh watch --once --json --idle-threshold 999999 >"$TMPDIR/watch.json"
cue vet "$TMPDIR/watch.json" model/contract.cue -d '#WatchSnapshot'
jq -e '
	.source == "fixture"
	and .include_detached == false
	and .summary == {"active": 1, "detached": 0, "orphan": 1, "quiet": 1, "total": 3}
	and .mesh_root == "/home/galeavenworth/lab"
	and .workspace_scan_depth == 1
	and (.workspaces[] | select(.workspace_role == "mesh-root").name) == "lab"
	and ([.workspaces[] | select(.beads_status == "missing").name] == ["lab-notes"])
	and ([.rows[].state] | sort) == ["active", "orphan", "quiet"]
	and (.rows[] | select(.state == "active").task_id) == "mesh-active"
	and (.rows[] | select(.state == "active").workspace) == "codex-mesh"
	and (.rows[] | select(.state == "active").last_output_known) == true
	and (.rows[] | select(.state == "quiet").task_id) == "mesh-quiet"
	and (.rows[] | select(.state == "quiet").last_output_known) == false
	and (.rows[] | select(.state == "orphan").address) == "codex-watch-orphan"
	and (.rows[] | select(.state == "orphan").workspace) == "lab-notes"
	and (.rows[] | select(.state == "orphan").beads_status) == "missing"
' "$TMPDIR/watch.json" >/dev/null
CODEX_MESH_NOW=1783390200 scripts/mesh session render --profile operator --watch-snapshot "$TMPDIR/watch.json" >"$TMPDIR/operator.kitty-session"
grep -q '^new_tab mesh$' "$TMPDIR/operator.kitty-session"
grep -q '^launch --title mesh-watch sh -lc' "$TMPDIR/operator.kitty-session"
grep -q '^new_tab codex-mesh$' "$TMPDIR/operator.kitty-session"
if grep -q 'codex_' "$TMPDIR/operator.kitty-session"; then
	echo "verify: session render must not persist codex_* vars" >&2
	exit 1
fi
if grep -q 'codex --' "$TMPDIR/operator.kitty-session"; then
	echo "verify: session render must not relaunch codex agents" >&2
	exit 1
fi
CODEX_MESH_NOW=1783390200 scripts/mesh session render --profile operator --json --watch-snapshot "$TMPDIR/watch.json" >"$TMPDIR/session-render.json"
cue vet "$TMPDIR/session-render.json" model/contract.cue -d '#KittySessionRender'
jq -e '
	.record_type == "kitty_session_render"
	and .profile == "operator"
	and .source == "watch-snapshot"
	and .rendering_policy.relaunches_agents == false
	and .rendering_policy.uses_codex_user_vars == false
	and .rendered_workspace_count == 3
	and .rendered_agent_count == 3
	and (.session_file.lines[] | select(. == "new_tab mesh"))
' "$TMPDIR/session-render.json" >/dev/null
CODEX_MESH_NOW=1783390200 scripts/mesh session render --profile operator --watch-snapshot "$TMPDIR/watch.json" --output "$TMPDIR/operator-out.kitty-session" | grep -q "$TMPDIR/operator-out.kitty-session"
test -s "$TMPDIR/operator-out.kitty-session"
CODEX_MESH_KITTY_LS_FILE=tests/kitty-ls-watch.json CODEX_MESH_WORKSPACES_FILE=tests/workspaces-watch.json CODEX_MESH_TRANSCRIPT_DIR="$TMPDIR/transcripts" CODEX_MESH_NOW="$(date +%s)" scripts/mesh watch --once --idle-threshold 999999 | grep -q 'agents=3 rows=3 active=1 quiet=1 detached=0 orphan=1'
CODEX_MESH_KITTY_LS_FILE=tests/kitty-ls-watch.json CODEX_MESH_WORKSPACES_FILE=tests/workspaces-watch.json CODEX_MESH_TRANSCRIPT_DIR="$TMPDIR/transcripts" CODEX_MESH_NOW="$(date +%s)" scripts/mesh watch --once --ndjson --idle-threshold 999999 | jq -e '.record_type == "watch_snapshot" and .include_detached == false and .summary.total == 3 and .summary.detached == 0 and (.workspaces | length) == 3' >/dev/null
CODEX_MESH_KITTY_LS_FILE=tests/kitty-ls-watch.json CODEX_MESH_WORKSPACES_FILE=tests/workspaces-watch.json CODEX_MESH_TRANSCRIPT_DIR="$TMPDIR/transcripts" CODEX_MESH_NOW="$(date +%s)" scripts/mesh watch --once --json --include-detached --idle-threshold 999999 >"$TMPDIR/watch-include-detached.json"
cue vet "$TMPDIR/watch-include-detached.json" model/contract.cue -d '#WatchSnapshot'
jq -e '
	.include_detached == true
	and .summary == {"active": 1, "detached": 1, "orphan": 1, "quiet": 1, "total": 4}
	and ([.rows[].state] | sort) == ["active", "detached", "orphan", "quiet"]
	and (.rows[] | select(.state == "detached").task_id) == "mesh-detached"
' "$TMPDIR/watch-include-detached.json" >/dev/null

mkdir -p "$TMPDIR/no-beads-cwd"
env -u CODEX_MESH_ROOT CODEX_MESH_KITTY_LS_FILE="$ROOT/tests/kitty-ls-empty.json" CODEX_MESH_TRANSCRIPT_DIR="$TMPDIR/transcripts" CODEX_MESH_NOW="$(date +%s)" "$ROOT/scripts/mesh" watch --once --json >"$TMPDIR/watch-no-db.json"
(
	cd "$TMPDIR/no-beads-cwd"
	env -u CODEX_MESH_ROOT CODEX_MESH_KITTY_LS_FILE="$ROOT/tests/kitty-ls-empty.json" CODEX_MESH_TRANSCRIPT_DIR="$TMPDIR/transcripts" CODEX_MESH_NOW="$(date +%s)" "$ROOT/scripts/mesh" watch --once --json >"$TMPDIR/watch-no-db-cwd.json"
)
cue vet "$TMPDIR/watch-no-db-cwd.json" model/contract.cue -d '#WatchSnapshot'
jq -e '
	.summary.total == 0
	and (.workspaces | length) == 1
	and .workspaces[0].beads_status == "missing"
	and .workspaces[0].task_count == 0
' "$TMPDIR/watch-no-db-cwd.json" >/dev/null
mkdir -p "$TMPDIR/mesh-root/alpha/nested" "$TMPDIR/mesh-root/beta"
"$ROOT/scripts/codex-mesh-workspaces" --mesh-root "$TMPDIR/mesh-root" >"$TMPDIR/workspaces-missing.json"
jq -e '
	.mesh_root == $root
	and .workspace_scan_depth == 1
	and ([.workspaces[].name] | sort) == ["alpha", "beta"]
	and ([.workspaces[].beads_status] | unique) == ["missing"]
	and (.tasks | length) == 0
' --arg root "$TMPDIR/mesh-root" "$TMPDIR/workspaces-missing.json" >/dev/null
mkdir -p "$TMPDIR/mesh-root-backed/.beads" "$TMPDIR/mesh-root-backed/project/.beads"
mkdir -p "$TMPDIR/fake-bd-bin"
cat >"$TMPDIR/fake-bd-bin/bd" <<'SH'
#!/usr/bin/env bash
root=""
if [[ "${1:-}" == "-C" ]]; then
	root="$2"
	shift 2
fi
if [[ "$*" != "list --status=open,in_progress,hooked --json" ]]; then
	exit 64
fi
case "$(basename "$root")" in
mesh-root-backed)
	printf '[]\n'
	;;
project)
	printf '[{"id":"mesh-proj","title":"project task","status":"open"}]\n'
	;;
*)
	exit 65
	;;
esac
SH
chmod +x "$TMPDIR/fake-bd-bin/bd"
PATH="$TMPDIR/fake-bd-bin:$PATH" "$ROOT/scripts/codex-mesh-workspaces" --mesh-root "$TMPDIR/mesh-root-backed" >"$TMPDIR/workspaces-backed-root.json"
jq -e '
	.mesh_root == $root
	and .workspace_scan_depth == 1
	and (.workspaces | length) == 2
	and .workspaces[0].name == "mesh-root-backed"
	and .workspaces[0].workspace_role == "mesh-root"
	and .workspaces[0].beads_status == "available"
	and .workspaces[0].task_count == 0
	and .workspaces[1].name == "project"
	and .workspaces[1].workspace_role == "project"
	and .workspaces[1].beads_status == "available"
	and .workspaces[1].task_count == 1
	and .tasks[0].id == "mesh-proj"
	and .tasks[0].workspace == "project"
' --arg root "$TMPDIR/mesh-root-backed" "$TMPDIR/workspaces-backed-root.json" >/dev/null

mkdir -p "$TMPDIR/mesh-root-validate/.beads" "$TMPDIR/mesh-root-validate/project/.beads" "$TMPDIR/mesh-root-validate/notes"
cat >"$TMPDIR/mesh-root-validate/workspace.cue" <<'CUE'
workspace: {
	record_type: "workspace_declaration"
	name: "mesh-root-validate"
	kind: "mesh"
	workflow_class: "coordinator"
	child: false
	default_formulas: ["cue-first-feature", "review-wave", "judge-panel", "loop-until-dry", "completeness-critic"]
}
CUE
cat >"$TMPDIR/mesh-root-validate/project/workspace.cue" <<'CUE'
workspace: {
	record_type: "workspace_declaration"
	name: "project"
	kind: "software-project"
	workflow_class: "implementation"
	child: true
	default_formulas: ["cue-first-feature", "review-wave", "judge-panel", "loop-until-dry", "completeness-critic"]
}
CUE
cat >"$TMPDIR/mesh-root-validate/notes/workspace.cue" <<'CUE'
workspace: {
	record_type: "workspace_declaration"
	name: "notes"
	kind: "notes"
	workflow_class: "reference"
	child: true
	default_formulas: ["review-wave", "judge-panel", "completeness-critic"]
}
CUE
mkdir -p "$TMPDIR/fake-bd-validate"
cat >"$TMPDIR/fake-bd-validate/bd" <<'SH'
#!/usr/bin/env bash
root=""
if [[ "${1:-}" == "-C" ]]; then
	root="$2"
	shift 2
fi
name="$(basename "$root")"
prefix="$name"
case "$name" in
mesh-root-validate) prefix="labv" ;;
project) prefix="projv" ;;
esac
if [[ "${DUP_PREFIX:-0}" == "1" ]]; then
	prefix="dupv"
fi
case "$*" in
"list --status=open,in_progress,hooked --json")
	printf '[]\n'
	;;
"context --json")
	printf '{"backend":"dolt","bd_version":"1.1.0","beads_dir":"%s/.beads","cwd_repo_root":"%s","database":"%s","dolt_mode":"embedded","is_redirected":false,"is_worktree":false,"project_id":"%s-id","repo_root":"%s","role":"maintainer","schema_version":1}\n' "$root" "$root" "$name" "$name" "$root"
	;;
"where --json")
	printf '{"database_path":"%s/.beads/embeddeddolt","path":"%s/.beads","prefix":"%s","schema_version":1}\n' "$root" "$root" "$prefix"
	;;
"config show --json")
	printf '[]\n'
	;;
"config get issue_prefix")
	printf '%s\n' "$prefix"
	;;
*)
	exit 64
	;;
esac
SH
chmod +x "$TMPDIR/fake-bd-validate/bd"
PATH="$TMPDIR/fake-bd-validate:$PATH" "$ROOT/scripts/mesh" workspaces --json --mesh-root "$TMPDIR/mesh-root-validate" >"$TMPDIR/workspaces-validation.json"
cue vet "$TMPDIR/workspaces-validation.json" model/contract.cue -d '#WorkspaceValidation'
jq -e '
	.record_type == "workspace_validation"
	and .status == "valid"
	and .workspace_scan_depth == 1
	and .beads_command == "bd -C <workspace> list --status=open,in_progress,hooked --json"
	and (.workspaces | length) == 3
	and ([.workspaces[].name] | sort) == ["mesh-root-validate", "notes", "project"]
	and ([.workspaces[] | select(.discovered.beads_status == "available") | .beads.prefix] | sort) == ["labv", "projv"]
	and (.workspaces[] | select(.name == "notes").kind) == "notes"
	and (.workspaces[] | select(.name == "notes").discovered.beads_status) == "missing"
	and (.errors | length) == 0
' "$TMPDIR/workspaces-validation.json" >/dev/null
DUP_PREFIX=1 PATH="$TMPDIR/fake-bd-validate:$PATH" "$ROOT/scripts/mesh" workspaces --json --mesh-root "$TMPDIR/mesh-root-validate" >"$TMPDIR/workspaces-duplicate-prefix.json"
jq -e '
	.status == "invalid"
	and ([.errors[].code] | index("duplicate-bd-prefix"))
' "$TMPDIR/workspaces-duplicate-prefix.json" >/dev/null

context_file="$TMPDIR/contexts.json"
CODEX_MESH_CONTEXT_FILE="$context_file" scripts/mesh context bind --mesh-root "$ROOT/.." --listen-on unix:/tmp/codex-mesh-test --json >"$TMPDIR/context-binding.json"
cue vet "$TMPDIR/context-binding.json" model/contract.cue -d '#KittyContextBinding'
CODEX_MESH_CONTEXT_FILE="$context_file" KITTY_LISTEN_ON=unix:/tmp/wrong scripts/mesh context resolve --mesh-root "$ROOT/.." --cwd "$ROOT" --json >"$TMPDIR/context-resolution.json"
cue vet "$TMPDIR/context-resolution.json" model/contract.cue -d '#KittyContextResolution'
jq -e '
	.source == "mesh-root-config"
	and .mesh_root == $root
	and .cwd == $cwd
	and .kitty_listen_on == "unix:/tmp/codex-mesh-test"
' --arg root "$(cd "$ROOT/.." && pwd -P)" --arg cwd "$ROOT" "$TMPDIR/context-resolution.json" >/dev/null

mkdir -p "$TMPDIR/fake-bin"
cat >"$TMPDIR/fake-bin/kitty" <<'SH'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"$KITTY_ARGS_LOG"
if [[ "${1:-}" != "@" ]]; then
	exit 64
fi
shift
if [[ "${1:-}" == "--to" ]]; then
	shift 2
fi
case "${1:-}" in
ls)
	cat "$KITTY_LS_PAYLOAD"
	;;
launch)
	printf '%s\n' "${KITTY_FAKE_WINDOW_ID:-42}"
	;;
send-text)
	for arg in "$@"; do
		if [[ "$arg" == "--stdin" ]]; then
			cat >/dev/null
			break
		fi
	done
	;;
*)
	;;
esac
SH
chmod +x "$TMPDIR/fake-bin/kitty"
cat >"$TMPDIR/fake-bin/codex" <<'SH'
#!/usr/bin/env bash
exit 0
SH
chmod +x "$TMPDIR/fake-bin/codex"

export KITTY_ARGS_LOG="$TMPDIR/kitty-args.log"
export KITTY_LS_PAYLOAD="$ROOT/tests/kitty-ls-single.json"
PATH="$TMPDIR/fake-bin:$PATH" CODEX_MESH_CONTEXT_FILE="$context_file" KITTY_LISTEN_ON=unix:/tmp/wrong scripts/mesh agents --mesh-root "$ROOT/.." --json >"$TMPDIR/context-agents.json"
grep -q '^@ --to unix:/tmp/codex-mesh-test ls$' "$KITTY_ARGS_LOG"
jq -e '.agents | length == 1' "$TMPDIR/context-agents.json" >/dev/null

>"$KITTY_ARGS_LOG"
PATH="$TMPDIR/fake-bin:$PATH" CODEX_MESH_CONTEXT_FILE="$context_file" KITTY_LISTEN_ON=unix:/tmp/wrong CODEX_MESH_TRANSCRIPT_DISABLE=1 scripts/spawn --addr codex-context-test --mesh-root "$ROOT/.." "$ROOT" "context spawn" >"$TMPDIR/context-spawn.out"
grep -q '^@ --to unix:/tmp/codex-mesh-test ls$' "$KITTY_ARGS_LOG"
grep -q '^@ --to unix:/tmp/codex-mesh-test launch ' "$KITTY_ARGS_LOG"
grep -q -- '--env KITTY_LISTEN_ON=unix:/tmp/codex-mesh-test' "$KITTY_ARGS_LOG"
grep -q '^window_id=42$' "$TMPDIR/context-spawn.out"

>"$KITTY_ARGS_LOG"
export KITTY_LS_PAYLOAD="$ROOT/tests/kitty-ls-watch.json"
PATH="$TMPDIR/fake-bin:$PATH" CODEX_MESH_CONTEXT_FILE="$context_file" KITTY_LISTEN_ON=unix:/tmp/wrong CODEX_MESH_WORKSPACES_FILE=tests/workspaces-watch.json CODEX_MESH_TRANSCRIPT_DIR="$TMPDIR/transcripts" CODEX_MESH_NOW="$(date +%s)" scripts/mesh watch --once --json --mesh-root "$ROOT/.." --idle-threshold 999999 >"$TMPDIR/context-watch.json"
cue vet "$TMPDIR/context-watch.json" model/contract.cue -d '#WatchSnapshot'
grep -q '^@ --to unix:/tmp/codex-mesh-test ls$' "$KITTY_ARGS_LOG"
jq -e '
	.kitty_context.source == "mesh-root-config"
	and .kitty_context.kitty_listen_on == "unix:/tmp/codex-mesh-test"
	and .summary.total == 3
' "$TMPDIR/context-watch.json" >/dev/null

CODEX_MESH_BD_READY_FILE=tests/bd-ready-wave.json scripts/mesh wave dispatch model/fixtures/valid-wave-request.json >"$TMPDIR/wave-status.json"
cue vet "$TMPDIR/wave-status.json" model/contract.cue -d '#WaveStatus'
jq -e '
	.frontier_source == "fixture"
	and .spawned_count == 2
	and .skipped_count == 1
	and .frontier_remaining == 0
	and ([.records[] | select(.status == "planned") | .task] | sort) == ["mesh-9ln.5", "mesh-9ln.6"]
	and ([.records[] | select(.status == "skipped") | .task] | sort) == ["mesh-9ln.7"]
	and ([.records[] | select(.task == "mesh-dy4.1")] | length) == 0
' "$TMPDIR/wave-status.json" >/dev/null

scripts/mesh cookbook render --json \
	--cookbook "$ROOT/model/fixtures/valid-context-cookbook-implementation.json" \
	--role implementation \
	--task mesh-9ln.5 \
	--title "implement: wave dispatch runtime" >"$TMPDIR/cookbook-render.json"
cue vet "$TMPDIR/cookbook-render.json" model/contract.cue -d '#CookbookRenderedPrompt'
jq -e '
	.record_type == "cookbook_rendered_prompt"
	and .renderer == "context-cookbook-renderer"
	and .cookbook_id == "outcome-cookbook"
	and .role == "implementation"
	and .task == "mesh-9ln.5"
	and (.message | startswith("/goal Role"))
	and (.message | contains("Cookbook provenance:"))
' "$TMPDIR/cookbook-render.json" >/dev/null

jq --arg cookbook "$ROOT/model/fixtures/valid-context-cookbook-implementation.json" \
	'. + {cookbook: {path: $cookbook, role: "implementation"}}' \
	model/fixtures/valid-wave-request.json >"$TMPDIR/wave-request-cookbook.json"
CODEX_MESH_BD_READY_FILE=tests/bd-ready-wave.json scripts/mesh wave status "$TMPDIR/wave-request-cookbook.json" >"$TMPDIR/wave-cookbook-status.json"
cue vet "$TMPDIR/wave-cookbook-status.json" model/contract.cue -d '#WaveStatus'
jq -e '
	.request.cookbook.role == "implementation"
	and ([.records[] | select(.status == "planned") | .cookbook.renderer] | unique) == ["context-cookbook-renderer"]
	and ([.records[] | select(.status == "planned") | .cookbook.cookbook_id] | unique) == ["outcome-cookbook"]
	and ([.records[] | select(.status == "planned") | .message | startswith("/goal Role")] | all)
	and ([.records[] | select(.status == "planned") | .message | contains("Cookbook provenance:")] | all)
' "$TMPDIR/wave-cookbook-status.json" >/dev/null

CODEX_MESH_BD_READY_FILE=tests/bd-ready-wave-empty.json scripts/mesh wave dispatch model/fixtures/valid-wave-request.json >"$TMPDIR/wave-empty.json"
cue vet "$TMPDIR/wave-empty.json" model/contract.cue -d '#WaveStatus'
jq -e '
	.spawned_count == 0
	and .skipped_count == 0
	and .frontier_remaining == 0
	and (.records | length) == 0
' "$TMPDIR/wave-empty.json" >/dev/null

CODEX_MESH_DRY_RUN=1 CODEX_MESH_DRY_RUN_WINDOW_ID=12 CODEX_MESH_TRANSCRIPT_DIR="$TMPDIR/transcripts" scripts/spawn --addr codex-worktree-test --role implementation --isolation worktree --worktree-base "$TMPDIR/worktrees" "$ROOT" "/goal worktree dry run" >"$TMPDIR/spawn-worktree.out"
grep -q "^workdir=$TMPDIR/worktrees/codex-worktree-test$" "$TMPDIR/spawn-worktree.out"
grep -q "^codex_worktree=$TMPDIR/worktrees/codex-worktree-test$" "$TMPDIR/spawn-worktree.out"

CODEX_MESH_BD_READY_FILE=tests/bd-ready-isolation-wave.json scripts/mesh wave dispatch model/fixtures/valid-wave-request-mutating-worktree.json >"$TMPDIR/wave-worktree.json"
cue vet "$TMPDIR/wave-worktree.json" model/contract.cue -d '#WaveStatus'
jq -e '
	.request.mutating == true
	and .request.isolation.mode == "worktree"
	and .spawned_count == 2
	and ([.records[] | select(.status == "planned") | .worktree_path] | sort) == [
		"/tmp/codex-mesh-worktrees/codex-wave-mesh-dy4-5",
		"/tmp/codex-mesh-worktrees/codex-wave-mesh-dy4-6"
	]
' "$TMPDIR/wave-worktree.json" >/dev/null
if CODEX_MESH_BD_READY_FILE=tests/bd-ready-isolation-wave.json scripts/mesh wave dispatch model/fixtures/invalid-wave-request-mutating-no-isolation.json >/dev/null 2>&1; then
	echo "verify: mutating wave without worktree isolation unexpectedly dispatched" >&2
	exit 1
fi

scripts/mesh workflow plan model/fixtures/valid-workflow-request-review-wave.json >"$TMPDIR/workflow-plan.json"
cue vet "$TMPDIR/workflow-plan.json" model/contract.cue -d '#WorkflowRun'
jq -e '
	.mode == "plan"
	and .status == "planned"
	and .bounded == true
	and .dry_run == true
	and .live_mutation == false
	and (.formula_run.steps | length) == 2
	and .decisions[0].action == "dispatch"
	and .decisions[0].placement.repo_id == "codex-mesh"
	and .decisions[0].placement.isolation_mode == "shared_checkout"
	and .decisions[1].action == "wait"
' "$TMPDIR/workflow-plan.json" >/dev/null

scripts/mesh workflow run model/fixtures/valid-workflow-request-mutating-worktree.json >"$TMPDIR/workflow-run.json"
cue vet "$TMPDIR/workflow-run.json" model/contract.cue -d '#WorkflowRun'
jq -e '
	.mode == "run"
	and .status == "running"
	and .dry_run == true
	and .live_mutation == false
	and .decisions[0].action == "dispatch"
	and .decisions[0].placement.execution_mode == "mutating"
	and .decisions[0].placement.isolation_mode == "worktree"
	and .decisions[0].placement.beads.task_claim_required == true
' "$TMPDIR/workflow-run.json" >/dev/null

CODEX_MESH_DRY_RUN=1 CODEX_MESH_DRY_RUN_WINDOW_ID=42 scripts/mesh workflow run model/fixtures/valid-workflow-live-request-mutating-worktree.json >"$TMPDIR/workflow-live-run.json"
cue vet "$TMPDIR/workflow-live-run.json" model/contract.cue -d '#WorkflowRun'
jq -e '
	.mode == "run"
	and .status == "running"
	and .dry_run == false
	and .live_mutation == true
	and .request.live_dispatch_policy.spawn_adapter == "scripts/codex-mesh-wave spawn_task"
	and .live_dispatch_result.record_type == "workflow_live_dispatch_result"
	and .live_dispatch_result.spawned_count == 1
	and .live_dispatch_result.attempts[0].dispatch.status == "spawned"
	and .live_dispatch_result.attempts[0].dispatch.session_id == "42"
' "$TMPDIR/workflow-live-run.json" >/dev/null

scripts/mesh workflow status model/fixtures/valid-workflow-request-review-wave.json >"$TMPDIR/workflow-status.json"
cue vet "$TMPDIR/workflow-status.json" model/contract.cue -d '#WorkflowRun'
jq -e '.mode == "status" and .status == "running"' "$TMPDIR/workflow-status.json" >/dev/null

if scripts/mesh workflow plan model/fixtures/valid-workflow-live-request-mutating-worktree.json >/dev/null 2>"$TMPDIR/workflow-live-plan.err"; then
	echo "verify: workflow runner accepted live mutation outside run mode" >&2
	exit 1
fi
grep -q 'only valid for mesh workflow run' "$TMPDIR/workflow-live-plan.err"
if scripts/mesh workflow plan model/fixtures/invalid-workflow-run-provider-secret.json >/dev/null 2>"$TMPDIR/workflow-secret.err"; then
	echo "verify: workflow runner accepted provider-specific request" >&2
	exit 1
fi
grep -q 'forbidden' "$TMPDIR/workflow-secret.err"
if scripts/mesh workflow run model/fixtures/invalid-workflow-request-mutating-shared-checkout.json >/dev/null 2>"$TMPDIR/workflow-mutating-shared.err"; then
	echo "verify: workflow runner accepted mutating shared-checkout request" >&2
	exit 1
fi
grep -q 'mutating workflow requests' "$TMPDIR/workflow-mutating-shared.err"

jq -n --arg root "$ROOT" --arg state "$TMPDIR/goal-state" '
	{
		record_type: "goal_predicate",
		task: "mesh-t8h.5",
		description: "The offline goal-state file exists.",
		frozen: true,
		red_check_required: true,
		close_requires_green: true,
		check: {
			kind: "command",
			cwd: $root,
			command: ["test", "-f", $state],
			expected_exit_code: 0,
			side_effect_free: true,
			timeout_seconds: 5
		},
		adversarial: [
			{
				label: "missing file",
				reason: "The predicate must be red before fixture work creates the file.",
				expected_status: "red"
			}
		]
	}
' >"$TMPDIR/goal-predicate.json"
cue vet "$TMPDIR/goal-predicate.json" model/contract.cue -d '#GoalPredicate'

CODEX_MESH_NOW=1783278120 scripts/mesh goal check --phase red-check "$TMPDIR/goal-predicate.json" >"$TMPDIR/goal-red.json"
cue vet "$TMPDIR/goal-red.json" model/contract.cue -d '#GoalEvaluation'
jq -e '.phase == "red-check" and .status == "red" and .exit_code != .predicate.check.expected_exit_code' "$TMPDIR/goal-red.json" >/dev/null
jq -n --slurpfile predicate "$TMPDIR/goal-predicate.json" --slurpfile red "$TMPDIR/goal-red.json" '
	{
		record_type: "goal_loop_start",
		task: "mesh-t8h.5",
		predicate: $predicate[0],
		red_check: $red[0]
	}
' >"$TMPDIR/goal-start.json"
cue vet "$TMPDIR/goal-start.json" model/contract.cue -d '#GoalLoopStart'

touch "$TMPDIR/goal-state"
CODEX_MESH_NOW=1783278180 scripts/mesh goal check --phase close "$TMPDIR/goal-predicate.json" >"$TMPDIR/goal-green.json"
cue vet "$TMPDIR/goal-green.json" model/contract.cue -d '#GoalEvaluation'
jq -e '.phase == "close" and .status == "green" and .exit_code == .predicate.check.expected_exit_code' "$TMPDIR/goal-green.json" >/dev/null
jq -n --slurpfile predicate "$TMPDIR/goal-predicate.json" --slurpfile green "$TMPDIR/goal-green.json" '
	($green[0].evidence + {label: "goal close"}) as $evidence
	| {
		record_type: "goal_loop_close",
		task: "mesh-t8h.5",
		predicate: $predicate[0],
		close_evaluation: $green[0],
		result: {
			record_type: "result_envelope",
			task: "mesh-t8h.5",
			session_id: "7",
			address: "codex-implementation-1",
			role: "implementation",
			status: "completed",
			completed_at_unix: 1783278180,
			evidence: [$evidence],
			payload: {
				kind: "implementation",
				summary: "Offline goal predicate reached green.",
				changed_files: [],
				verification: [$evidence]
			}
		}
	}
' >"$TMPDIR/goal-close.json"
cue vet "$TMPDIR/goal-close.json" model/contract.cue -d '#GoalLoopClose'

CODEX_MESH_DRY_RUN=1 CODEX_MESH_DRY_RUN_WINDOW_ID=7 CODEX_MESH_TRANSCRIPT_DIR="$TMPDIR/transcripts" scripts/spawn --addr codex-test-spawn --role implementation "$ROOT" "hello from spawn" | grep -q '^codex_addr=codex-test-spawn$'
CODEX_MESH_DRY_RUN=1 CODEX_MESH_DRY_RUN_WINDOW_ID=7 CODEX_MESH_TRANSCRIPT_DIR="$TMPDIR/transcripts" scripts/spawn --addr codex-test-spawn-b --role implementation "$ROOT" "hello from spawn" | grep -q '^codex_transcript=.*/7.ansi$'
if CODEX_MESH_DRY_RUN=1 CODEX_MESH_TRANSCRIPT_DISABLE=1 scripts/spawn --addr codex-test-spawn-c --role implementation "$ROOT" "hello from spawn" | grep -q '^codex_transcript='; then
	echo "verify: spawn emitted a transcript path while transcript logging was disabled" >&2
	exit 1
fi
CODEX_MESH_DRY_RUN=1 CODEX_MESH_DRY_RUN_WINDOW_ID=8 CODEX_MESH_TRANSCRIPT_DIR="$TMPDIR/transcripts" scripts/jump --no-close --addr codex-test-jump --role successor "$ROOT" "hello from jump" | grep -q '^parent_close=dry-run$'
if CODEX_MESH_DRY_RUN=1 CODEX_MESH_DRY_RUN_WINDOW_ID=7 CODEX_MESH_TRANSCRIPT_DIR="$TMPDIR/transcripts" CODEX_MESH_KITTY_LS_FILE=tests/kitty-ls-single.json scripts/spawn --addr codex-implementation-1 --role implementation "$ROOT" "duplicate spawn" >/dev/null 2>&1; then
	echo "verify: spawn unexpectedly allowed an existing address" >&2
	exit 1
fi
if CODEX_MESH_DRY_RUN=1 CODEX_MESH_DRY_RUN_WINDOW_ID=7 CODEX_MESH_TRANSCRIPT_DIR="$TMPDIR/transcripts" CODEX_MESH_KITTY_LS_FILE=tests/kitty-ls-duplicate.json scripts/jump --no-close --addr codex-implementation-1 --role successor "$ROOT" "duplicate jump" >/dev/null 2>&1; then
	echo "verify: jump unexpectedly allowed a duplicate address" >&2
	exit 1
fi

git diff --check
