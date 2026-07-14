#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

need() {
	command -v "$1" >/dev/null 2>&1 || {
		echo "verify-contract: missing required command: $1" >&2
		exit 1
	}
}

need bash
need cue
expect_cue_vet_failure() {
	local fixture="$1"
	local definition="$2"
	local label="$3"
	if cue vet "$fixture" model/contract.cue -d "$definition" >/dev/null 2>&1; then
		echo "verify: invalid $label fixture unexpectedly passed" >&2
		exit 1
	fi
}

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
cue vet model/fixtures/valid-reclaim-policy-no-stale-timer.json model/contract.cue -d '#ReclaimPolicy'
cue vet model/fixtures/valid-reclaim-diagnosis-live-agent-no-action.json model/contract.cue -d '#ReclaimDiagnosis'
cue vet model/fixtures/valid-reclaim-diagnosis-transcript-backed.json model/contract.cue -d '#ReclaimDiagnosis'
cue vet model/fixtures/valid-reclaim-decision-requeue-transcript-backed.json model/contract.cue -d '#ReclaimDecision'
cue vet model/fixtures/valid-reclaim-decision-operator-staleness-decision.json model/contract.cue -d '#ReclaimDecision'
cue vet model/fixtures/valid-reclaim-sweep-dry-run.json model/contract.cue -d '#ReclaimSweepResult'
cue vet model/fixtures/valid-result-envelope-implementation.json model/contract.cue -d '#ResultEnvelope'
cue vet model/fixtures/valid-result-envelope-reviewer.json model/contract.cue -d '#ResultEnvelope'
cue vet model/fixtures/valid-result-envelope-judge.json model/contract.cue -d '#ResultEnvelope'
cue vet model/fixtures/valid-goal-predicate.json model/contract.cue -d '#GoalPredicate'
cue vet model/fixtures/valid-goal-evaluation-red.json model/contract.cue -d '#GoalEvaluation'
cue vet model/fixtures/valid-goal-loop-start.json model/contract.cue -d '#GoalLoopStart'
cue vet model/fixtures/valid-goal-loop-close.json model/contract.cue -d '#GoalLoopClose'
cue vet model/fixtures/valid-goal-loop-escape.json model/contract.cue -d '#GoalLoopEscape'
cue vet model/fixtures/valid-goal-decomposition.json model/contract.cue -d '#GoalDecomposition'
cue vet model/fixtures/valid-integration-predicate-formula.json model/contract.cue -d '#IntegrationPredicate'
cue vet model/fixtures/valid-goal-composition-formula-two-level.json model/contract.cue -d '#GoalComposition'
cue vet model/fixtures/valid-composition-closeout-two-level.json model/contract.cue -d '#CompositionCloseout'
cue vet model/fixtures/valid-goal-composition-gate-resume.json model/contract.cue -d '#GoalComposition'
cue vet model/fixtures/valid-goal-composition-swarm.json model/contract.cue -d '#GoalComposition'
cue vet model/fixtures/valid-wave-request.json model/contract.cue -d '#WaveRequest'
cue vet model/fixtures/valid-wave-status.json model/contract.cue -d '#WaveStatus'
cue vet model/fixtures/valid-isolation-policy-worktree.json model/contract.cue -d '#IsolationPolicy'
cue vet model/fixtures/valid-spawn-worktree-isolation.json model/contract.cue -d '#SpawnRequest'
cue vet model/fixtures/valid-wave-request-mutating-worktree.json model/contract.cue -d '#WaveRequest'
cue vet model/fixtures/valid-watch-command.json model/contract.cue -d '#WatchCommand'
cue vet model/fixtures/valid-watch-snapshot.json model/contract.cue -d '#WatchSnapshot'
cue vet model/fixtures/valid-watch-snapshot-include-detached.json model/contract.cue -d '#WatchSnapshot'
cue vet model/fixtures/valid-workspace-validation.json model/contract.cue -d '#WorkspaceValidation'
cue vet model/fixtures/valid-session-render-command.json model/contract.cue -d '#KittySessionRenderCommand'
cue vet model/fixtures/valid-session-render.json model/contract.cue -d '#KittySessionRender'
cue vet model/fixtures/valid-formula-cue-first-feature.json model/contract.cue -d '#Formula'
cue vet model/fixtures/valid-formula-review-wave.json model/contract.cue -d '#Formula'
cue vet model/fixtures/valid-formula-judge-panel.json model/contract.cue -d '#Formula'
cue vet model/fixtures/valid-formula-loop-until-dry.json model/contract.cue -d '#Formula'
cue vet model/fixtures/valid-formula-completeness-critic.json model/contract.cue -d '#Formula'
cue vet model/fixtures/valid-workflow-request-review-wave.json model/contract.cue -d '#WorkflowRequest'
cue vet model/fixtures/valid-workflow-request-mutating-worktree.json model/contract.cue -d '#WorkflowRequest'
cue vet model/fixtures/valid-workflow-run-readonly-shared.json model/contract.cue -d '#WorkflowRun'
cue vet model/fixtures/valid-workflow-run-mutating-worktrees.json model/contract.cue -d '#WorkflowRun'
cue vet model/fixtures/valid-workflow-live-authorization.json model/contract.cue -d '#WorkflowLiveAuthorization'
cue vet model/fixtures/valid-workflow-live-request-mutating-worktree.json model/contract.cue -d '#WorkflowRequest'
cue vet model/fixtures/valid-workflow-live-run-dispatch.json model/contract.cue -d '#WorkflowRun'
cue vet model/fixtures/valid-workflow-live-dispatch-result.json model/contract.cue -d '#WorkflowLiveDispatchResult'
cue vet model/fixtures/valid-federation-role-coordinator.json model/contract.cue -d '#FederationRole'
cue vet model/fixtures/valid-federation-role-project-manager.json model/contract.cue -d '#FederationRole'
cue vet model/fixtures/valid-federation-workspace-ref-lab-root.json model/contract.cue -d '#FederationWorkspaceRef'
cue vet model/fixtures/valid-federation-workspace-ref-project.json model/contract.cue -d '#FederationWorkspaceRef'
cue vet model/fixtures/valid-federation-cookbook-bundle-project-manager.json model/contract.cue -d '#FederationCookbookBundle'
cue vet model/fixtures/valid-federation-delegation-coordinator-to-pm.json model/contract.cue -d '#FederationDelegation'
cue vet model/fixtures/valid-federation-result-envelope-project-manager.json model/contract.cue -d '#FederationResultEnvelope'
cue vet model/fixtures/valid-federation-result-envelope-coordinator.json model/contract.cue -d '#FederationResultEnvelope'
cue vet model/fixtures/valid-federation-capability-ref-ship-dry-run.json model/contract.cue -d '#FederationCapabilityRef'
cue vet model/fixtures/valid-federation-gate-ref-bead-check.json model/contract.cue -d '#FederationGateRef'
cue vet model/fixtures/valid-federation-project-manager-run.json model/contract.cue -d '#FederationProjectManagerRun'
cue vet model/fixtures/valid-federation-coordinator-run.json model/contract.cue -d '#FederationCoordinatorRun'
cue vet model/fixtures/valid-federation-smoke-two-workspace.json model/contract.cue -d '#FederationSmoke'
cue vet model/fixtures/valid-formula-run-main-owned-merge.json model/contract.cue -d '#FormulaRun'
cue vet model/fixtures/valid-orchestration-default.json model/contract.cue -d '#OrchestrationDefault'
cue vet model/fixtures/valid-orchestration-default-rollout-deferral.json model/contract.cue -d '#OrchestrationDefault'
cue vet model/fixtures/valid-context-cookbook-implementation.json model/contract.cue -d '#ContextCookbook'
cue vet model/fixtures/valid-context-cookbook-review-exec.json model/contract.cue -d '#ContextCookbook'
cue vet model/fixtures/valid-cookbook-role-bundle-probe.json model/contract.cue -d '#CookbookRoleBundle'
cue vet model/fixtures/valid-prompt-render-policy-goal-first.json model/contract.cue -d '#PromptRenderPolicy'
cue vet skills/codex-mesh/agents/openai.yaml model/contract.cue -d '#AgentSkillInterface'
for formula in cue-first-feature review-wave judge-panel loop-until-dry completeness-critic; do
	cue vet ".beads/formulas/$formula.formula.json" model/contract.cue -d '#Formula'
done
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
expect_cue_vet_failure model/fixtures/invalid-reclaim-policy-stale-timer.json '#ReclaimPolicy' 'reclaim policy stale timer'
expect_cue_vet_failure model/fixtures/invalid-reclaim-policy-transcript-idle-age.json '#ReclaimPolicy' 'reclaim policy transcript idle age'
expect_cue_vet_failure model/fixtures/invalid-reclaim-diagnosis-open-task.json '#ReclaimDiagnosis' 'reclaim diagnosis open task'
expect_cue_vet_failure model/fixtures/invalid-reclaim-diagnosis-missing-assignee.json '#ReclaimDiagnosis' 'reclaim diagnosis missing assignee'
expect_cue_vet_failure model/fixtures/invalid-reclaim-diagnosis-unknown-agent-name.json '#ReclaimDiagnosis' 'reclaim diagnosis unknown agent name'
expect_cue_vet_failure model/fixtures/invalid-reclaim-decision-live-agent-release.json '#ReclaimDecision' 'reclaim live agent release'
expect_cue_vet_failure model/fixtures/invalid-reclaim-decision-missing-transcript-requeues.json '#ReclaimDecision' 'reclaim missing transcript requeue'
expect_cue_vet_failure model/fixtures/invalid-reclaim-decision-unfit-releases-claim.json '#ReclaimDecision' 'reclaim unfit claim release'
expect_cue_vet_failure model/fixtures/invalid-reclaim-sweep-persisted-liveness.json '#ReclaimSweepResult' 'reclaim persisted liveness'
expect_cue_vet_failure model/fixtures/invalid-reclaim-sweep-daemon.json '#ReclaimSweepResult' 'reclaim daemon'
expect_cue_vet_failure model/fixtures/invalid-reclaim-sweep-unverified-bd-command.json '#ReclaimDecision' 'reclaim unverified bd command'
expect_cue_vet_failure model/fixtures/invalid-reclaim-codex-yolo-default.json '#ReclaimSweepResult' 'reclaim codex yolo default'
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
expect_cue_vet_failure model/fixtures/invalid-integration-predicate-child-conjunction.json '#IntegrationPredicate' 'integration predicate child-conjunction'
expect_cue_vet_failure model/fixtures/invalid-goal-composition-missing-integration-predicate.json '#GoalComposition' 'goal composition missing integration-predicate'
expect_cue_vet_failure model/fixtures/invalid-goal-composition-integration-wrong-task.json '#GoalComposition' 'goal composition wrong-task integration'
expect_cue_vet_failure model/fixtures/invalid-goal-composition-child-green-only.json '#CompositionCloseout' 'goal composition child-green-only'
expect_cue_vet_failure model/fixtures/invalid-composition-closeout-missing-parent-predicate-evidence.json '#CompositionCloseout' 'composition closeout missing parent predicate evidence'
expect_cue_vet_failure model/fixtures/invalid-composition-closeout-wrong-task-envelope.json '#CompositionEnvelopeEvidence' 'composition closeout wrong-task envelope'
expect_cue_vet_failure model/fixtures/invalid-composition-closeout-text-only-envelope.json '#CompositionEnvelopeEvidence' 'composition closeout text-only envelope'
expect_cue_vet_failure model/fixtures/invalid-composition-closeout-duplicate-envelope.json '#CompositionEnvelopeEvidence' 'composition closeout duplicate envelope'
expect_cue_vet_failure model/fixtures/invalid-composition-gate-ready-without-gate-proof.json '#GoalComposition' 'composition gate ready without gate proof'
expect_cue_vet_failure model/fixtures/invalid-composition-scheduler-durable-store.json '#GoalComposition' 'composition scheduler durable-store'
expect_cue_vet_failure model/fixtures/invalid-composition-kitty-lifecycle.json '#GoalComposition' 'composition kitty lifecycle'
expect_cue_vet_failure model/fixtures/invalid-composition-codex-subagent-lifecycle.json '#GoalComposition' 'composition codex subagent lifecycle'
expect_cue_vet_failure model/fixtures/invalid-composition-provider-secret.json '#GoalComposition' 'composition provider secret'
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
expect_cue_vet_failure model/fixtures/invalid-session-render-codex-vars.json '#KittySessionRender' 'session render codex vars'
expect_cue_vet_failure model/fixtures/invalid-session-render-relaunch-agent.json '#KittySessionRender' 'session render relaunch agent'
expect_cue_vet_failure model/fixtures/invalid-session-render-durable-store.json '#KittySessionRender' 'session render durable store'
for fixture in \
	model/fixtures/invalid-workspace-missing-cue.json \
	model/fixtures/invalid-workspace-invalid-cue.json \
	model/fixtures/invalid-workspace-unknown-kind.json \
	model/fixtures/invalid-workspace-class-not-allowed.json \
	model/fixtures/invalid-workspace-role-mismatch.json \
	model/fixtures/invalid-workspace-root-child-mismatch.json \
	model/fixtures/invalid-workspace-formula-not-allowed.json \
	model/fixtures/invalid-workspace-beads-required.json \
	model/fixtures/invalid-workspace-duplicate-bd-prefix.json \
	model/fixtures/invalid-workspace-prefix-unreadable.json \
	model/fixtures/invalid-workspace-forbidden-private-field.json \
	model/fixtures/invalid-workspace-forbidden-live-state.json \
	model/fixtures/invalid-workspace-unsupported-scan-depth.json
do
	if cue vet "$fixture" model/contract.cue -d '#WorkspaceValidation' >/dev/null 2>&1; then
		echo "verify: invalid workspace fixture unexpectedly passed: $fixture" >&2
		exit 1
	fi
done
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
if cue vet model/fixtures/invalid-workflow-live-implicit-default.json model/contract.cue -d '#WorkflowRequest' >/dev/null 2>&1; then
	echo "verify: invalid live workflow implicit default unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-workflow-live-missing-authorization.json model/contract.cue -d '#WorkflowRequest' >/dev/null 2>&1; then
	echo "verify: invalid live workflow missing authorization unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-workflow-live-unresolved-gate.json model/contract.cue -d '#WorkflowLiveAuthorization' >/dev/null 2>&1; then
	echo "verify: invalid live workflow unresolved gate unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-workflow-live-cap-over-guidance.json model/contract.cue -d '#WorkflowLiveAuthorization' >/dev/null 2>&1; then
	echo "verify: invalid live workflow cap over guidance unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-workflow-live-mutating-shared-checkout.json model/contract.cue -d '#WorkflowRequest' >/dev/null 2>&1; then
	echo "verify: invalid live workflow mutating shared checkout unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-workflow-live-hidden-scheduler.json model/contract.cue -d '#WorkflowLiveDispatchResult' >/dev/null 2>&1; then
	echo "verify: invalid live workflow hidden scheduler unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-workflow-live-stale-mol-ready-gated.json model/contract.cue -d '#WorkflowLiveDispatchPolicy' >/dev/null 2>&1; then
	echo "verify: invalid live workflow stale gated-ready primitive unexpectedly passed" >&2
	exit 1
fi
if cue vet model/fixtures/invalid-workflow-live-silent-truncation.json model/contract.cue -d '#WorkflowLiveDispatchResult' >/dev/null 2>&1; then
	echo "verify: invalid live workflow silent truncation unexpectedly passed" >&2
	exit 1
fi
expect_cue_vet_failure model/fixtures/invalid-federation-direct-child-edit.json '#FederationDelegation' federation-direct-child-edit
expect_cue_vet_failure model/fixtures/invalid-federation-second-task-db.json '#FederationDelegation' federation-second-task-db
expect_cue_vet_failure model/fixtures/invalid-federation-persisted-liveness-window-id.json '#FederationWorkspaceRef' federation-persisted-liveness-window-id
expect_cue_vet_failure model/fixtures/invalid-federation-missing-comment-anchor.json '#FederationDelegation' federation-missing-comment-anchor
expect_cue_vet_failure model/fixtures/invalid-federation-pm-result-without-child-envelopes.json '#FederationResultEnvelope' federation-pm-result-without-child-envelopes
expect_cue_vet_failure model/fixtures/invalid-federation-native-subagent-lifecycle.json '#FederationDelegation' federation-native-subagent-lifecycle
expect_cue_vet_failure model/fixtures/invalid-federation-global-assumed.json '#FederationWorkspaceRef' federation-global-assumed
expect_cue_vet_failure model/fixtures/invalid-federation-bead-gate-create-assumption.json '#FederationGateRef' federation-bead-gate-create-assumption
expect_cue_vet_failure model/fixtures/invalid-federation-workflow-false-task-id.json '#FederationDelegation' federation-workflow-false-task-id
expect_cue_vet_failure model/fixtures/invalid-federation-sync-scheduler.json '#FederationDelegation' federation-sync-scheduler
expect_cue_vet_failure model/fixtures/invalid-federation-provider-secret.json '#FederationCapabilityRef' federation-provider-secret
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
if cue vet model/fixtures/invalid-orchestration-default-missing-rollout-evidence.json model/contract.cue -d '#OrchestrationDefault' >/dev/null 2>&1; then
	echo "verify: invalid orchestration missing-rollout-evidence fixture unexpectedly passed" >&2
	exit 1
fi
for fixture in \
	model/fixtures/invalid-context-cookbook-missing-catalog-citation.json \
	model/fixtures/invalid-context-cookbook-missing-official-doc-citation.json \
	model/fixtures/invalid-context-cookbook-prose-only-output.json \
	model/fixtures/invalid-context-cookbook-provider-secret.json \
	model/fixtures/invalid-context-cookbook-raw-mcp-inventory.json \
	model/fixtures/invalid-context-cookbook-plugin-required-public-core.json \
	model/fixtures/invalid-context-cookbook-native-subagent-lifecycle.json \
	model/fixtures/invalid-context-cookbook-socket-scan.json \
	model/fixtures/invalid-context-cookbook-kitty-lifecycle-state.json \
	model/fixtures/invalid-context-cookbook-bd-jsonl-runtime-truth.json
do
	if cue vet "$fixture" model/contract.cue -d '#ContextCookbook' >/dev/null 2>&1; then
		echo "verify: invalid context cookbook fixture unexpectedly passed: $fixture" >&2
		exit 1
	fi
done
for fixture in \
	model/fixtures/invalid-cookbook-role-bundle-unknown-role.json \
	model/fixtures/invalid-cookbook-role-bundle-payload-mismatch.json \
	model/fixtures/invalid-cookbook-role-bundle-success-criteria-prose.json \
	model/fixtures/invalid-cookbook-role-bundle-missing-stop-rules.json
do
	if cue vet "$fixture" model/contract.cue -d '#CookbookRoleBundle' >/dev/null 2>&1; then
		echo "verify: invalid cookbook role bundle fixture unexpectedly passed: $fixture" >&2
		exit 1
	fi
done
for fixture in \
	model/fixtures/invalid-codex-launch-policy-yolo-default.json \
	model/fixtures/invalid-codex-launch-policy-full-access-no-worktree-reason.json \
	model/fixtures/invalid-codex-launch-policy-review-closes-beads.json \
	model/fixtures/invalid-codex-launch-policy-exec-no-schema.json
do
	if cue vet "$fixture" model/contract.cue -d '#CodexLaunchPolicy' >/dev/null 2>&1; then
		echo "verify: invalid codex launch policy fixture unexpectedly passed: $fixture" >&2
		exit 1
	fi
done
for fixture in \
	model/fixtures/invalid-prompt-render-policy-non-goal-template.json \
	model/fixtures/invalid-prompt-render-policy-hidden-dispatch.json \
	model/fixtures/invalid-prompt-render-policy-nondeterministic.json \
	model/fixtures/invalid-prompt-render-policy-send-text-proof.json
do
	if cue vet "$fixture" model/contract.cue -d '#PromptRenderPolicy' >/dev/null 2>&1; then
		echo "verify: invalid prompt render policy fixture unexpectedly passed: $fixture" >&2
		exit 1
	fi
done
