#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

need() {
	command -v "$1" >/dev/null 2>&1 || {
		echo "verify: missing required command: $1" >&2
		exit 1
	}
}

need bash
need cue
need jq
need python3
need bd

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

cue vet model/fixtures/valid-spawn.json model/contract.cue -d '#SpawnRequest'
cue vet model/fixtures/valid-mesh-init-dry-run.json model/contract.cue -d '#MeshInit'
cue vet model/fixtures/valid-install-doctor.json model/contract.cue -d '#InstallDoctor'
cue vet model/fixtures/valid-tell-resolution.json model/contract.cue -d '#TellResolution'
cue vet model/fixtures/valid-jump-result.json model/contract.cue -d '#JumpResult'
cue vet model/fixtures/valid-substrate-boundary.json model/contract.cue -d '#SubstrateBoundary'
cue vet model/fixtures/valid-public-core-boundary.json model/contract.cue -d '#PublicCoreBoundary'
cue vet model/fixtures/valid-address-preflight-launchable.json model/contract.cue -d '#AddressPreflight'
cue vet model/fixtures/valid-transcript-policy.json model/contract.cue -d '#TranscriptPolicy'
cue vet model/fixtures/valid-kitty-context-binding.json model/contract.cue -d '#KittyContextBinding'
cue vet model/fixtures/valid-kitty-context-resolution-config.json model/contract.cue -d '#KittyContextResolution'
cue vet model/fixtures/valid-kitty-context-resolution-current.json model/contract.cue -d '#KittyContextResolution'
cue vet model/fixtures/valid-kitty-context-resolution-env.json model/contract.cue -d '#KittyContextResolution'
cue vet model/fixtures/valid-live-agent-snapshot.json model/contract.cue -d '#LiveAgentSnapshot'
cue vet model/fixtures/valid-session-attachment.json model/contract.cue -d '#SessionAttachment'
cue vet model/fixtures/valid-mesh-beads-join.json model/contract.cue -d '#MeshBeadsJoin'
cue vet model/fixtures/valid-result-envelope-implementation.json model/contract.cue -d '#ResultEnvelope'
cue vet model/fixtures/valid-result-envelope-reviewer.json model/contract.cue -d '#ResultEnvelope'
cue vet model/fixtures/valid-result-envelope-judge.json model/contract.cue -d '#ResultEnvelope'
cue vet model/fixtures/valid-goal-predicate.json model/contract.cue -d '#GoalPredicate'
cue vet model/fixtures/valid-goal-evaluation-red.json model/contract.cue -d '#GoalEvaluation'
cue vet model/fixtures/valid-goal-loop-start.json model/contract.cue -d '#GoalLoopStart'
cue vet model/fixtures/valid-goal-loop-close.json model/contract.cue -d '#GoalLoopClose'
cue vet model/fixtures/valid-goal-loop-escape.json model/contract.cue -d '#GoalLoopEscape'
cue vet model/fixtures/valid-goal-decomposition.json model/contract.cue -d '#GoalDecomposition'
cue vet model/fixtures/valid-wave-request.json model/contract.cue -d '#WaveRequest'
cue vet model/fixtures/valid-wave-status.json model/contract.cue -d '#WaveStatus'
cue vet model/fixtures/valid-isolation-policy-worktree.json model/contract.cue -d '#IsolationPolicy'
cue vet model/fixtures/valid-spawn-worktree-isolation.json model/contract.cue -d '#SpawnRequest'
cue vet model/fixtures/valid-wave-request-mutating-worktree.json model/contract.cue -d '#WaveRequest'
cue vet model/fixtures/valid-watch-command.json model/contract.cue -d '#WatchCommand'
cue vet model/fixtures/valid-watch-snapshot.json model/contract.cue -d '#WatchSnapshot'
cue vet model/fixtures/valid-watch-snapshot-include-detached.json model/contract.cue -d '#WatchSnapshot'
cue vet model/fixtures/valid-formula-cue-first-feature.json model/contract.cue -d '#Formula'
cue vet model/fixtures/valid-formula-review-wave.json model/contract.cue -d '#Formula'
cue vet model/fixtures/valid-formula-judge-panel.json model/contract.cue -d '#Formula'
cue vet model/fixtures/valid-formula-loop-until-dry.json model/contract.cue -d '#Formula'
cue vet model/fixtures/valid-formula-completeness-critic.json model/contract.cue -d '#Formula'
cue vet model/fixtures/valid-workflow-request-review-wave.json model/contract.cue -d '#WorkflowRequest'
cue vet model/fixtures/valid-workflow-request-mutating-worktree.json model/contract.cue -d '#WorkflowRequest'
cue vet model/fixtures/valid-workflow-run-readonly-shared.json model/contract.cue -d '#WorkflowRun'
cue vet model/fixtures/valid-workflow-run-mutating-worktrees.json model/contract.cue -d '#WorkflowRun'
cue vet model/fixtures/valid-formula-run-main-owned-merge.json model/contract.cue -d '#FormulaRun'
cue vet model/fixtures/valid-orchestration-default.json model/contract.cue -d '#OrchestrationDefault'
cue vet skills/codex-mesh/agents/openai.yaml model/contract.cue -d '#AgentSkillInterface'
bd formula list >"$TMPDIR/formula-list.txt"
for formula in cue-first-feature review-wave judge-panel loop-until-dry completeness-critic; do
	cue vet ".beads/formulas/$formula.formula.json" model/contract.cue -d '#Formula'
	grep -q "  $formula " "$TMPDIR/formula-list.txt"
	bd mol wisp create "$formula" --dry-run >/dev/null
done
bd mol pour cue-first-feature --dry-run >/dev/null

if cue vet model/fixtures/invalid-spawn-closes-parent.json model/contract.cue -d '#SpawnRequest' >/dev/null 2>&1; then
	echo "verify: invalid spawn fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-mesh-init-provider-specific-source.json model/contract.cue -d '#MeshInit' >/dev/null 2>&1; then
	echo "verify: invalid mesh init provider-specific source fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-install-doctor-auto-install.json model/contract.cue -d '#InstallDoctor' >/dev/null 2>&1; then
	echo "verify: invalid install doctor auto-install fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-task-not-beads-id.json model/contract.cue -d '#SpawnRequest' >/dev/null 2>&1; then
	echo "verify: invalid beads task fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-tell-zero-match-deliverable.json model/contract.cue -d '#TellResolution' >/dev/null 2>&1; then
	echo "verify: invalid tell fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-jump-unconfirmed-ready.json model/contract.cue -d '#JumpResult' >/dev/null 2>&1; then
	echo "verify: invalid jump fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-substrate-boundary-routes-owned-here.json model/contract.cue -d '#SubstrateBoundary' >/dev/null 2>&1; then
	echo "verify: invalid substrate ownership fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-substrate-boundary-stale-command.json model/contract.cue -d '#SubstrateBoundary' >/dev/null 2>&1; then
	echo "verify: invalid substrate command fixture unexpectedly passed" >&2
	exit 1
fi
for fixture in \
	model/fixtures/invalid-public-core-secret-ref.json \
	model/fixtures/invalid-public-core-private-plugin-in-core.json \
	model/fixtures/invalid-public-core-missing-operator-session-logs.json \
	model/fixtures/invalid-public-core-workflow-authority.json \
	model/fixtures/invalid-public-core-formula-dry-runs-missing.json
do
	if cue vet "$fixture" model/contract.cue -d '#PublicCoreBoundary' >/dev/null 2>&1; then
		echo "verify: invalid public-core boundary fixture unexpectedly passed: $fixture" >&2
		exit 1
	fi
done
if cue vet model/fixtures/invalid-address-preflight-existing-launchable.json model/contract.cue -d '#AddressPreflight' >/dev/null 2>&1; then
	echo "verify: invalid address preflight fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-transcript-filters-output.json model/contract.cue -d '#TranscriptPolicy' >/dev/null 2>&1; then
	echo "verify: invalid transcript filtering fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-transcript-records-stdin.json model/contract.cue -d '#TranscriptPolicy' >/dev/null 2>&1; then
	echo "verify: invalid transcript stdin fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-kitty-context-env-missing-listen.json model/contract.cue -d '#KittyContextResolution' >/dev/null 2>&1; then
	echo "verify: invalid kitty context env fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-kitty-context-socket-scan.json model/contract.cue -d '#KittyContextResolution' >/dev/null 2>&1; then
	echo "verify: invalid kitty context socket-scan fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-kitty-context-window-store.json model/contract.cue -d '#KittyContextBinding' >/dev/null 2>&1; then
	echo "verify: invalid kitty context window-store fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-live-agent-durable-store.json model/contract.cue -d '#LiveAgentSnapshot' >/dev/null 2>&1; then
	echo "verify: invalid live snapshot durable-store fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-session-attachment-live-state.json model/contract.cue -d '#SessionAttachment' >/dev/null 2>&1; then
	echo "verify: invalid session attachment live-state fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-mesh-beads-join-durable-store.json model/contract.cue -d '#MeshBeadsJoin' >/dev/null 2>&1; then
	echo "verify: invalid mesh-beads join durable-store fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-mesh-beads-join-per-agent-calls.json model/contract.cue -d '#MeshBeadsJoin' >/dev/null 2>&1; then
	echo "verify: invalid mesh-beads join per-agent-calls fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-mesh-beads-join-open-resume-signal.json model/contract.cue -d '#MeshBeadsJoin' >/dev/null 2>&1; then
	echo "verify: invalid mesh-beads join resume-signal fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-result-envelope-prose-only.json model/contract.cue -d '#ResultEnvelope' >/dev/null 2>&1; then
	echo "verify: invalid result envelope prose-only fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-result-envelope-unknown-status.json model/contract.cue -d '#ResultEnvelope' >/dev/null 2>&1; then
	echo "verify: invalid result envelope unknown-status fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-result-envelope-missing-task.json model/contract.cue -d '#ResultEnvelope' >/dev/null 2>&1; then
	echo "verify: invalid result envelope missing-task fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-result-envelope-role-payload-mismatch.json model/contract.cue -d '#ResultEnvelope' >/dev/null 2>&1; then
	echo "verify: invalid result envelope role-payload fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-goal-predicate-mutable.json model/contract.cue -d '#GoalPredicate' >/dev/null 2>&1; then
	echo "verify: invalid goal predicate mutable fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-goal-evaluation-non-predicate-evidence.json model/contract.cue -d '#GoalEvaluation' >/dev/null 2>&1; then
	echo "verify: invalid goal evaluation evidence fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-goal-loop-start-green-redcheck.json model/contract.cue -d '#GoalLoopStart' >/dev/null 2>&1; then
	echo "verify: invalid goal loop green red-check fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-goal-loop-close-red-evaluation.json model/contract.cue -d '#GoalLoopClose' >/dev/null 2>&1; then
	echo "verify: invalid goal loop red close fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-goal-loop-close-missing-evidence.json model/contract.cue -d '#GoalLoopClose' >/dev/null 2>&1; then
	echo "verify: invalid goal loop missing evidence fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-wave-request-zero-cap.json model/contract.cue -d '#WaveRequest' >/dev/null 2>&1; then
	echo "verify: invalid wave request zero-cap fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-wave-request-non-goal-prompt.json model/contract.cue -d '#WaveRequest' >/dev/null 2>&1; then
	echo "verify: invalid wave request non-goal fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-wave-status-exceeds-cap.json model/contract.cue -d '#WaveStatus' >/dev/null 2>&1; then
	echo "verify: invalid wave status exceeds-cap fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-isolation-none-with-worktree-base.json model/contract.cue -d '#IsolationPolicy' >/dev/null 2>&1; then
	echo "verify: invalid isolation none-with-worktree-base fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-wave-request-mutating-no-isolation.json model/contract.cue -d '#WaveRequest' >/dev/null 2>&1; then
	echo "verify: invalid mutating wave without isolation fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-watch-command-budget.json model/contract.cue -d '#WatchCommand' >/dev/null 2>&1; then
	echo "verify: invalid watch command budget fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-watch-command-recursive-scan.json model/contract.cue -d '#WatchCommand' >/dev/null 2>&1; then
	echo "verify: invalid watch recursive-scan fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-watch-row-active-missing-task.json model/contract.cue -d '#WatchRow' >/dev/null 2>&1; then
	echo "verify: invalid watch active missing-task fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-watch-row-detached-with-agent.json model/contract.cue -d '#WatchRow' >/dev/null 2>&1; then
	echo "verify: invalid watch detached-with-agent fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-watch-snapshot-durable-store.json model/contract.cue -d '#WatchSnapshot' >/dev/null 2>&1; then
	echo "verify: invalid watch durable-store fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-watch-snapshot-default-detached.json model/contract.cue -d '#WatchSnapshot' >/dev/null 2>&1; then
	echo "verify: invalid watch default-detached fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-watch-snapshot-thinking-state.json model/contract.cue -d '#WatchSnapshot' >/dev/null 2>&1; then
	echo "verify: invalid watch thinking-state fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-watch-workspace-missing-task-count.json model/contract.cue -d '#WatchWorkspace' >/dev/null 2>&1; then
	echo "verify: invalid watch missing-workspace task-count fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-watch-workspace-root-missing-beads.json model/contract.cue -d '#WatchWorkspace' >/dev/null 2>&1; then
	echo "verify: invalid watch mesh-root missing-beads fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-formula-step-missing-goal.json model/contract.cue -d '#Formula' >/dev/null 2>&1; then
	echo "verify: invalid formula missing-goal fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-formula-mutating-wave-no-worktree.json model/contract.cue -d '#Formula' >/dev/null 2>&1; then
	echo "verify: invalid formula mutating wave fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-workflow-request-mutating-shared-checkout.json model/contract.cue -d '#WorkflowRequest' >/dev/null 2>&1; then
	echo "verify: invalid workflow mutating shared-checkout request unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-workflow-run-mutating-shared-checkout.json model/contract.cue -d '#WorkflowRun' >/dev/null 2>&1; then
	echo "verify: invalid workflow mutating shared-checkout run unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-workflow-run-missing-result-envelope-close.json model/contract.cue -d '#WorkflowStepState' >/dev/null 2>&1; then
	echo "verify: invalid workflow missing result-envelope close unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-workflow-run-failed-predicate-close.json model/contract.cue -d '#RunnerDecision' >/dev/null 2>&1; then
	echo "verify: invalid workflow failed-predicate close unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-workflow-run-hidden-dispatch.json model/contract.cue -d '#RunnerDecision' >/dev/null 2>&1; then
	echo "verify: invalid workflow hidden dispatch unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-workflow-run-provider-secret.json model/contract.cue -d '#WorkflowRequest' >/dev/null 2>&1; then
	echo "verify: invalid workflow provider-specific request unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-workflow-run-mutating-no-claim.json model/contract.cue -d '#WorkflowStepState' >/dev/null 2>&1; then
	echo "verify: invalid workflow mutating no-claim fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-orchestration-default-solo.json model/contract.cue -d '#OrchestrationDefault' >/dev/null 2>&1; then
	echo "verify: invalid orchestration solo-default fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-orchestration-default-daemon.json model/contract.cue -d '#OrchestrationDefault' >/dev/null 2>&1; then
	echo "verify: invalid orchestration daemon fixture unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-orchestration-default-prose-close.json model/contract.cue -d '#OrchestrationDefault' >/dev/null 2>&1; then
	echo "verify: invalid orchestration prose-close fixture unexpectedly passed" >&2
	exit 1
fi

for script in scripts/codex-mesh-lib.sh scripts/codex-mesh-doctor scripts/spawn scripts/tell scripts/jump scripts/mesh scripts/verify.sh; do
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
	and .mesh_root == "/workspace"
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

scripts/mesh workflow status model/fixtures/valid-workflow-request-review-wave.json >"$TMPDIR/workflow-status.json"
cue vet "$TMPDIR/workflow-status.json" model/contract.cue -d '#WorkflowRun'
jq -e '.mode == "status" and .status == "running"' "$TMPDIR/workflow-status.json" >/dev/null

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
