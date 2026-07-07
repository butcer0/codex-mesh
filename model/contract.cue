package model

#Backend: "kitty"

#Address:       string & =~"^[a-z][a-z0-9-]{1,63}$"
#Role:          string & =~"^[a-z][a-z0-9-]{1,31}$"
#BeadsIssueID:  string & =~"^[a-z][a-z0-9]*-[a-z0-9]+(-[a-z0-9]+)*(\\.[0-9]+)*$"
#BeadsPrefix:   string & =~"^[a-z][a-z0-9]*$"
#SessionID:     string & =~"^[1-9][0-9]*$"
#AbsPath:       string & =~"^/"
#NonEmpty:      string & !=""
#KittyListenOn: string & =~"^(unix|tcp):.+"

#AgentVars: {
	codex_addr:        #Address
	codex_role?:       #Role
	codex_parent?:     #Address
	codex_task?:       #BeadsIssueID
	codex_session?:    #SessionID
	codex_transcript?: #AbsPath
}

#CurrentBeadsPrimitive:               "bd ready" | "bd ready --json" | "bd ready --parent <epic> --exclude-type epic --json" | "bd ready --claim" | "bd ready --gated --json" | "bd show" | "bd update --claim" | "bd update --status open" | "bd assign" | "bd comment" | "bd comments" | "bd comments add" | "bd create" | "bd note" | "bd list --status=open,in_progress,hooked --json" | "bd -C <workspace> list --status=open,in_progress,hooked --json" | "bd swarm" | "bd swarm validate <epic> --json" | "bd swarm status <epic> --json" | "bd swarm validate mesh-mol-dru --json" | "bd swarm status mesh-mol-dru --json" | "bd gate" | "bd gate check --dry-run" | "bd gate check --type=bead --dry-run" | "bd merge-slot" | "bd merge-slot check" | "bd merge-slot acquire --holder <holder>" | "bd merge-slot release --holder <holder>" | "bd repo" | "bd repo list --json" | "bd federation status --json" | "bd federation list-peers --json" | "bd ship CAPABILITY --dry-run" | "bd mol" | "bd mol ready --json" | "bd formula list" | "bd -C WORKSPACE context --json"
#BeadsStatusCommand:                  "bd list --status=open,in_progress,hooked --json"
#BeadsWorkspaceCommand:               "bd -C <workspace> list --status=open,in_progress,hooked --json"
#WatchBeadsCommand:                   #BeadsStatusCommand | #BeadsWorkspaceCommand
#BeadsJoinStatus:                     "open" | "in_progress" | "hooked"
#ResultStatus:                        "completed" | "blocked" | "failed"
#EvidenceKind:                        "command" | "file" | "transcript" | "beads" | "predicate"
#GoalPhase:                           "red-check" | "iteration" | "close"
#GoalEvaluationStatus:                "red" | "green"
#WaveFrontierCommand:                 "bd ready --parent <epic> --exclude-type epic --json"
#WavePromptMode:                      "goal-first"
#WaveFrontierSource:                  "live-bd" | "fixture"
#DispatchStatus:                      "planned" | "spawned" | "skipped"
#DispatchSkipReason:                  "cap-reached" | "not-ready" | "already-live" | "spawn-failed"
#IsolationMode:                       "none" | "worktree"
#WorktreeCleanup:                     "remove-if-unchanged" | "manual"
#WorktreeCommand:                     "git worktree add --detach <path> HEAD"
#RepoID:                              string & =~"^[A-Za-z0-9._/-]+$"
#WorkflowRunMode:                     "plan" | "run" | "status"
#WorkflowRunStatus:                   "planned" | "running" | "blocked" | "completed" | "failed"
#WorkflowStepStatus:                  "blocked" | "ready" | "running" | "closed" | "failed" | "skipped"
#WorkflowExecutionMode:               "read_only" | "mutating" | "merge"
#WorkflowIsolationMode:               "shared_checkout" | "worktree" | "main_owned"
#WorkflowChannel:                     "spawn" | "tell" | "jump" | "none"
#RunnerDecisionAction:                "plan" | "dispatch" | "wait" | "close" | "block"
#WorkflowLiveAuthorizationSource:     "operator_gate"
#WorkflowLiveGateStatus:              "closed"
#WorkflowLiveScope:                   "lab-coordinator-delegated"
#WorkflowLiveKillSwitch:              "lights_off" | "broadcast_halt"
#WorkflowLiveDurableState:            "beads-comments-and-transcripts"
#WorkflowLiveJoinKey:                 "codex_task"
#WorkflowLiveSpawnAdapter:            "scripts/codex-mesh-wave spawn_task"
#WorkflowLiveSpawnCommand:            "scripts/spawn"
#WorkflowLiveFrontierCommand:         #WaveFrontierCommand | "bd ready --gated --json" | "bd mol ready --json"
#FederationRoleName:                  "coordinator" | "project-manager" | "implementation" | "reviewer" | "judge" | "probe"
#FederationRoleScope:                 "mesh-root" | "project-workspace"
#FederationTransport:                 "spawn" | "tell" | "jump"
#FederationHandoffSurface:            "beads_comment" | "skill" | "agents_md"
#FederationResultRole:                "coordinator" | "project-manager"
#FederationCapabilityProvider:        "beads-ship"
#FederationGateKind:                  "bead-check"
#FederationGateAwaitPattern:          string & =~"^[A-Za-z0-9._-]+:[a-z][a-z0-9]*-[a-z0-9]+(-[a-z0-9]+)*(\\.[0-9]+)*$"
#WatchState:                          "active" | "quiet" | "orphan" | "detached"
#WatchSource:                         "live" | "fixture"
#WatchOutputMode:                     "table" | "json" | "ndjson"
#SessionRenderProfile:                "operator"
#SessionRenderOutputMode:             "session" | "json"
#SessionRenderSource:                 "watch-snapshot"
#KittyContextSource:                  "mesh-root-config" | "env" | "current-kitty" | "fixture"
#WorkspaceName:                       string & =~"^[A-Za-z0-9._-]+$"
#WorkspaceRole:                       "mesh-root" | "project"
#BeadsWorkspaceStatus:                "available" | "missing" | "error" | "unknown"
#RemoteSource:                        "operator-config"
#FormulaName:                         string & =~"^[a-z][a-z0-9-]{1,63}$"
#WorkspaceKind:                       "mesh" | "software-project" | "notes"
#WorkspaceWorkflowClass:              "coordinator" | "implementation" | "reference"
#WorkspaceFormulaName:                #FormulaName & ("cue-first-feature" | "review-wave" | "judge-panel" | "loop-until-dry" | "completeness-critic")
#WorkspaceFullFormulaName:            #WorkspaceFormulaName & ("cue-first-feature" | "review-wave" | "judge-panel" | "loop-until-dry" | "completeness-critic")
#WorkspaceReferenceFormulaName:       #WorkspaceFormulaName & ("review-wave" | "judge-panel" | "completeness-critic")
#WorkspaceValidationStatus:           "valid" | "invalid"
#WorkspaceValidationCode:             "missing-workspace-cue" | "invalid-workspace-cue" | "declared-role-mismatch" | "mesh-root-child-mismatch" | "unknown-kind" | "workflow-class-not-allowed" | "formula-not-allowed" | "beads-required-for-kind" | "duplicate-bd-prefix" | "beads-prefix-unreadable" | "unsupported-extra-authority" | "forbidden-private-field" | "unsupported-scan-depth"
#WorkspaceBeadsEvidenceCommand:       "bd context --json" | "bd where --json" | "bd config show --json" | "bd config get issue_prefix"
#SoloException:                       "conversational-reply" | "single-read-lookup" | "trivial-mechanical-edit" | "emergency-transport-recovery"
#OrchestrationDispatch:               "mesh wave dispatch" | "mesh workflow run"
#FormulaStepID:                       string & =~"^[a-z][a-z0-9-]{1,63}$"
#FormulaType:                         "workflow"
#FormulaPhase:                        "solid" | "liquid" | "vapor"
#FormulaResultPayload:                "implementation" | "review_findings" | "verdict"
#OrchestrationClosePolicyName:        "green-predicate-result-envelope-and-rollout-adoption"
#InstallDependencyName:               "bash" | "python3" | "jq" | "git" | "bd" | "kitty" | "codex" | "cue"
#InstallDependencyUse:                "runtime" | "verification"
#InstallDependencyStatus:             "found" | "missing"
#CookbookID:                          #NonEmpty & =~"^[a-z][a-z0-9-]{1,63}$"
#CookbookSurface:                     "agents_md" | "skill" | "project_config" | "profile" | "mcp_server" | "codex_exec" | "codex_review" | "hook_rule" | "native_subagent" | "kitty_window" | "beads_comment" | "formula_metadata" | "transcript" | "catalog_citation" | "official_doc"
#CookbookLaunchMode:                  "interactive_kitty" | "noninteractive_exec" | "review"
#CookbookRole:                        "implementation" | "reviewer" | "judge" | "probe"
#CookbookResultPayload:               "implementation" | "review_findings" | "verdict"
#CookbookClosePolicyName:             "green-predicate-and-result-envelope"
#PromptRenderMode:                    "goal-first"
#CodexSandboxMode:                    "read-only" | "workspace-write" | "danger-full-access"
#CodexApprovalPolicy:                 "untrusted" | "on-request" | "never"
#CodexWebSearchMode:                  "cached" | "live" | "disabled"
#CodexModelID:                        "gpt-5.5" | "gpt-5.4" | "gpt-5.4-mini" | "gpt-5.3-codex-spark"
#CodexReasoningEffort:                "low" | "medium" | "high"
#CookbookFixtureExpectation:          "valid" | "invalid"
#CompositionSource:                   "bd-formula" | "bd-mol" | "bd-mol-bond" | "bd-mol-ready" | "bd-gate-resume" | "bd-swarm" | "bd-ready-frontier"
#CompositionClosePolicy:              "children-green-integration-green-and-result-envelope"
#IntegrationScope:                    "formula" | "molecule" | "bond" | "gate-resume" | "swarm" | "ready-frontier" | "rollout"
#IntegrationObligation:               "parent-predicate-distinct" | "all-required-child-closes-green" | "expected-result-payloads-match" | "formula-step-ordering" | "bond-shape-valid" | "gate-satisfaction" | "swarm-dag-valid" | "no-skipped-ready-frontier" | "mutating-exclusive-claim-or-worktree" | "structured-envelope-evidence" | "rollout-adoption-or-deferral"
#SourceSpecificIntegrationObligation: #IntegrationObligation & !="parent-predicate-distinct"
#CompositionEvidencePurpose:          "child-result-envelope" | "parent-integration-evaluation" | "formula-visibility" | "molecule-structure" | "bond-shape" | "gate-satisfaction" | "swarm-shape" | "frontier-accounting" | "exclusive-dispatch" | "repository-verifier" | "drift-gate"
#CompositionEvidencePrimitive:        "bd comments --json" | "bd show --json --include-comments" | "bd formula list" | "bd mol wisp create <formula> --dry-run" | "bd mol pour <formula> --dry-run" | "bd mol bond <A> <B> --dry-run" | "bd mol ready --json" | "bd mol progress <molecule-id> --json" | "bd mol current <molecule-id> --json" | "bd mol show <molecule-id> --json" | "bd ready --parent <epic> --exclude-type epic --json" | "bd ready --claim" | "bd ready --gated --json" | "bd gate check --dry-run" | "bd gate list" | "bd swarm validate <epic> --json" | "bd swarm status <epic> --json" | "mesh goal check --phase close <predicate>" | "./scripts/verify.sh"
#CompositionEvidenceOutputFormat:     "json" | "text" | "cue-vet" | "exit-code"
#CompositionEnvelopeSource:           "bd-comments-json" | "bd-show-json-include-comments" | "provided-result-envelopes"
#CompositionBondType:                 "sequential" | "parallel" | "conditional"
#CompositionBondPhasePolicy:          "inherit" | "pour" | "ephemeral"
#CompositionGateType:                 "human" | "timer" | "gh:run" | "gh:pr" | "bead"
#ReclaimMode:                         "diagnose_claimed_without_agent"
#ReclaimStaleTimer:                   "none"
#ReclaimCandidateSource:              "read-time-mesh-beads-join" | "read-time-watch-snapshot"
#ReclaimAgentIdentitySource:          "stable_or_derivable_agent_name"
#ReclaimTranscriptSource:             "transcript-path-or-beads-envelope"
#ReclaimDefaultExecution:             "dry_run"
#ReclaimClassification:               "live_agent_present" | "claimed_without_live_agent_transcript_backed" | "claimed_without_live_agent_unfit"
#ReclaimAction:                       "no_action" | "requeue_transcript_backed_work" | "operator_staleness_decision"
#ReclaimWispSurface:                  "bd mol wisp create <formula> --dry-run"
#ReclaimReleaseCommand:               "bd update <task> --status open" | "bd assign <task> \"\""
#ReclaimTaskCommentCommand:           "bd comments add <task> <message-or-file>"
#ReclaimTrackingCommand:              "bd create <tracking-bead>" | "bd comments add <tracking-bead> <message-or-file>"

#AgentSkillInterface: {
	interface: {
		display_name:      #NonEmpty
		short_description: #NonEmpty
		default_prompt:    string & =~"\\$codex-mesh"
	}
	policy?: {
		allow_implicit_invocation: true
	}
}

#MeshInitCommand: {
	argv: [...#NonEmpty] & [_, ...]
	status:     "planned" | "ran" | "skipped"
	cwd?:       #AbsPath
	reason?:    #NonEmpty
	exit_code?: int & >=0
	stdout?:    #NonEmpty
	stderr?:    #NonEmpty
}

#MeshInit: {
	record_type: "mesh_init"
	mesh_root:   #AbsPath
	prefix:      #BeadsPrefix
	dry_run:     bool
	commands: [...#MeshInitCommand] & [_, ...]

	private_origin?:  _|_
	remote_provider?: _|_
	secret_ref?:      _|_
} & ({
	remote_url:    #NonEmpty
	remote_source: #RemoteSource
} | {
	remote_url?:    _|_
	remote_source?: _|_
})

#InstallDependency: {
	name:         #InstallDependencyName
	required_for: #InstallDependencyUse
	status:       #InstallDependencyStatus
	purpose:      #NonEmpty
	path?:        #AbsPath

	if status == "found" {
		path: #AbsPath
	}
	if status == "missing" {
		path?: _|_
	}
}

#InstallDoctor: {
	record_type:        "install_doctor"
	scope:              "codex-mesh"
	dependency_policy:  "prerequisites-explicit"
	auto_install:       false
	install_command:    "make install"
	doctor_command:     "mesh doctor"
	runtime_ready:      bool
	verification_ready: bool
	dependencies: [...#InstallDependency] & [_, ...]

	package_manager_command?: _|_
	sudo?:                    _|_
	secret_ref?:              _|_
	private_origin?:          _|_
}

#KittyContextBinding: {
	record_type:      "kitty_context_binding"
	source:           "mesh-root-config"
	mesh_root:        #AbsPath
	kitty_listen_on:  #KittyListenOn
	config_path?:     #AbsPath
	updated_at_unix?: int & >=0

	socket_scan?:   _|_
	window_id?:     _|_
	pid?:           _|_
	liveness?:      _|_
	durable_store?: _|_
	scheduler?:     _|_
	daemon?:        _|_
}

#KittyContextResolution: {
	record_type:      "kitty_context_resolution"
	source:           #KittyContextSource
	mesh_root?:       #AbsPath
	cwd?:             #AbsPath
	kitty_listen_on?: #KittyListenOn
	config_path?:     #AbsPath

	if source == "mesh-root-config" {
		mesh_root:       #AbsPath
		kitty_listen_on: #KittyListenOn
		config_path:     #AbsPath
	}
	if source == "env" {
		kitty_listen_on: #KittyListenOn
	}
	if source == "current-kitty" {
		kitty_listen_on?: _|_
	}

	socket_scan?:   _|_
	window_id?:     _|_
	pid?:           _|_
	liveness?:      _|_
	durable_store?: _|_
	scheduler?:     _|_
	daemon?:        _|_
}

#SubstrateBoundary: {
	beads_version: "1.1.0"
	responsibilities: {
		task_graph:               "beads"
		work_assignment:          "beads"
		durable_handoff_context:  "beads"
		cross_repo_routing:       "beads"
		mesh_workspace_container: "beads"
		async_coordination:       "beads"
		merge_serialization:      "beads"

		live_process_launch:     "codex-mesh"
		live_address_resolution: "codex-mesh"
		prompt_delivery:         "codex-mesh"
		parent_window_close:     "codex-mesh"
		live_workspace_scan:     "codex-mesh"

		remote_configuration: "operator-config"
		secrets_and_infra:    "operator-config"
	}
	beads_primitives: [...#CurrentBeadsPrimitive] & [_, ...]
}

#RolloutAdoptionCloseout: {
	mode: "adoption"
	evidence: [...#ResultEvidence] & [_, ...]
}

#RolloutDeferralCloseout: {
	mode:          "deferral"
	tracking_bead: #BeadsIssueID
	reason:        #NonEmpty
}

#OrchestrationCloseout: {
	predicate_status:         "green"
	result_envelope_required: true
	rollout:                  #RolloutAdoptionCloseout | #RolloutDeferralCloseout
}

// The operating posture, not a command: substantive work defaults to
// formula-driven orchestration; solo execution must name its exception.
#OrchestrationDefault: {
	record_type:                   "orchestration_default"
	default_mode:                  "workflow"
	solo_requires_named_exception: true
	solo_exceptions: [...#SoloException] & [_, ...]

	decomposition: "beads-formula"
	dispatch:      #OrchestrationDispatch
	close_policy:  #OrchestrationClosePolicyName
	closeout:      #OrchestrationCloseout
	bounded:       true

	feature_formula:     #FormulaName & "cue-first-feature"
	review_formula:      #FormulaName & "review-wave"
	verdict_formula:     #FormulaName & "judge-panel"
	convergence_formula: #FormulaName & "loop-until-dry"
	closing_formula:     #FormulaName & "completeness-critic"

	daemon?:             _|_
	scheduler?:          _|_
	durable_store?:      _|_
	silent_caps?:        _|_
	unbounded_dispatch?: _|_
	prose_only_close?:   _|_
}

#PublicCoreExclusionProof: {
	status:   "forbidden"
	evidence: #NonEmpty
}

#PublicCoreForbiddenSurface: {
	operator_control_plane:        #PublicCoreExclusionProof
	credential_hotpath:            #PublicCoreExclusionProof
	password_manager:              #PublicCoreExclusionProof
	operator_git_service:          #PublicCoreExclusionProof
	operator_task_store:           #PublicCoreExclusionProof
	operator_task_remotes:         #PublicCoreExclusionProof
	credential_references:         #PublicCoreExclusionProof
	credential_values:             #PublicCoreExclusionProof
	operator_validation_artifacts: #PublicCoreExclusionProof
	operator_session_logs:         #PublicCoreExclusionProof
	service_account_env:           #PublicCoreExclusionProof
}

#PublicCoreFormulaDryRuns: [
	"cue-first-feature",
	"review-wave",
	"judge-panel",
	"loop-until-dry",
	"completeness-critic",
]

#PublicCoreBoundary: {
	record_type:   "public_core_boundary"
	project:       "codex-mesh"
	molecule:      "mesh-mol-9ns"
	lab_task:      "lab-w7f.6"
	live_mutation: false

	provider_boundary: {
		authority_bead:               "mesh-zm6"
		launch_contract:              "provider-neutral"
		core_secret_injection:        "forbidden"
		private_plugin_location:      "outside-public-core"
		private_plugin_may_implement: true
		forbidden:                    #PublicCoreForbiddenSurface

		private_origin?:                _|_
		remote_provider?:               _|_
		secret_ref?:                    _|_
		credential?:                    _|_
		credential_hotpath_dependency?: _|_
		service_account_env_value?:     _|_
	}

	workflow_boundary: {
		authority_bead:            "mesh-dj8"
		runner_scope:              "bounded-dry-run"
		hidden_dispatch:           "forbidden"
		provider_specific_fields:  "forbidden"
		close_policy:              "green-predicate-and-result-envelope"
		formula_dry_runs_required: true
		provider_secret_rejection: "scripts/codex-mesh-workflow"

		private_origin?:  _|_
		remote_provider?: _|_
		secret_ref?:      _|_
		credential?:      _|_
	}

	public_artifact_policy: {
		private_authority:             false
		private_launch_support:        false
		operator_provisioning:         false
		operator_validation_artifacts: "forbidden"
		operator_session_logs:         "forbidden"
		local_runtime_logs:            "not-public-artifact"
		log_paths_authority:           false
	}

	verification: {
		script:                            "./scripts/verify.sh"
		valid_fixture:                     "model/fixtures/valid-public-core-boundary.json"
		provider_secret_rejection_fixture: "model/fixtures/invalid-workflow-run-provider-secret.json"
		workflow_baseline:                 "mesh-dj8"
		formula_dry_runs:                  #PublicCoreFormulaDryRuns
		adversarial_fixtures: {
			secret_ref:                    "model/fixtures/invalid-public-core-secret-ref.json"
			private_plugin_in_core:        "model/fixtures/invalid-public-core-private-plugin-in-core.json"
			missing_operator_session_logs: "model/fixtures/invalid-public-core-missing-operator-session-logs.json"
			workflow_authority:            "model/fixtures/invalid-public-core-workflow-authority.json"
			formula_dry_runs_missing:      "model/fixtures/invalid-public-core-formula-dry-runs-missing.json"
		}
	}

	private_origin?:               _|_
	remote_provider?:              _|_
	secret_ref?:                   _|_
	credential?:                   _|_
	op_ref?:                       _|_
	token?:                        _|_
	operator_validation_artifact?: _|_
	operator_session_log_path?:    _|_
	operator_task_remote?:         _|_
	operator_network_remote?:      _|_
}

#TransportWindow: {
	window_id: int & >0
	title:     #NonEmpty
	cwd:       #AbsPath
	user_vars: #AgentVars
}

#TranscriptPolicy: {
	enabled:            true
	per_session:        true
	transport:          "pty"
	format:             "ansi"
	capture:            "output-bytes"
	records_stdin:      false
	semantic_filtering: false
	disable_env:        "CODEX_MESH_TRANSCRIPT_DISABLE"
	session_id:         #SessionID
	path:               #AbsPath
}

#LiveAgentSnapshot: {
	exposure:       "live-query"
	durable_store?: _|_
	session_id:     #SessionID
	window_id:      int & >0
	address:        #Address
	role?:          #Role
	parent?:        #Address
	task?:          #BeadsIssueID
	cwd:            #AbsPath
	pid?:           int & >0
	cmdline?: [...string]
	transcript_path?:  #AbsPath
	transcript_exists: bool
	transcript_bytes?: int & >=0
	last_output_unix?: int & >=0
	idle_seconds?:     int & >=0
	working_state:     "active" | "idle" | "unknown"
}

#SessionAttachment: {
	record_type:      "session_attachment"
	task:             #BeadsIssueID
	session_id:       #SessionID
	address:          #Address
	role?:            #Role
	cwd:              #AbsPath
	transcript_path:  #AbsPath
	category:         "session-started" | "session-ended" | "handoff"
	occurred_at_unix: int & >=0
	reason?:          string

	pid?:              _|_
	cmdline?:          _|_
	idle_seconds?:     _|_
	last_output_unix?: _|_
	working_state?:    _|_
	window_liveness?:  _|_
	live?:             _|_
	heartbeat?:        _|_
	durable_store?:    _|_
}

#BeadsTaskSnapshot: {
	id:     #BeadsIssueID
	title:  #NonEmpty
	status: #BeadsJoinStatus

	workspace?:        #WorkspaceName
	workspace_root?:   #AbsPath
	beads_status?:     #BeadsWorkspaceStatus
	priority?:         int & >=0 & <=4
	issue_type?:       #NonEmpty
	assignee?:         #NonEmpty
	parent?:           #BeadsIssueID
	dependency_count?: int & >=0
	dependent_count?:  int & >=0
	comment_count?:    int & >=0
}

#MeshBeadsJoin: {
	exposure:           "read-time-join"
	beads_command:      #BeadsStatusCommand
	generated_at_unix?: int & >=0
	agents: [...#LiveAgentSnapshot]
	tasks: [...#BeadsTaskSnapshot]
	records: [...#MeshBeadsJoinRecord]

	durable_store?:      _|_
	per_agent_bd_calls?: _|_
	per_issue_bd_calls?: _|_
	heartbeat?:          _|_
}

#MeshBeadsJoinRecord: #LiveAgentWithTaskRecord | #LiveAgentWithoutTaskRecord | #TaskWithoutLiveSessionRecord

#LiveAgentWithTaskRecord: {
	classification: "live_agent_with_task"
	task_id:        #BeadsIssueID
	agent: #LiveAgentSnapshot & {task: task_id}
	task: #BeadsTaskSnapshot & {id: task_id}
	resume_signal?: false
}

#LiveAgentWithoutTaskRecord: {
	classification: "live_agent_without_task"
	agent:          #LiveAgentSnapshot
	task_id?:       #BeadsIssueID
	task?:          _|_
	resume_signal?: false
}

#TaskWithoutLiveSessionRecord: {
	classification: "task_without_live_session"
	task_id:        #BeadsIssueID
	task: #BeadsTaskSnapshot & {id: task_id}
	agent?: _|_
} & ({
	task: {status: "open"}
	resume_signal: false
} | {
	task: {status: "in_progress" | "hooked"}
	resume_signal: true
})

#ReclaimCommandEvidence: {
	command:  #ReclaimReleaseCommand | #ReclaimTaskCommentCommand | #ReclaimTrackingCommand
	dry_run:  bool | *true
	executed: bool | *false
}

#ReclaimTranscriptEvidence: {
	exists: bool
	path?:  #AbsPath
	bytes?: int & >=0

	if exists == true {
		path:  #AbsPath
		bytes: int & >0
	}
	if exists == false {
		path?:  _|_
		bytes?: _|_
	}

	idle_seconds?: _|_
	heartbeat?:    _|_
	window_id?:    _|_
	pid?:          _|_
	liveness?:     _|_
}

#ReclaimPolicy: {
	record_type: "reclaim_policy"
	mode:        #ReclaimMode
	stale_timer: #ReclaimStaleTimer
	policy_authority: #ResultEvidence & {kind: "beads"}
	candidate_source:      #ReclaimCandidateSource
	agent_identity_source: #ReclaimAgentIdentitySource
	transcript_source:     #ReclaimTranscriptSource
	default_execution:     #ReclaimDefaultExecution
	release_commands: [
		"bd update <task> --status open",
		"bd assign <task> \"\"",
	]
	tracking_bead_commands: [
		"bd create <tracking-bead>",
		"bd comments add <tracking-bead> <message-or-file>",
	]
	evidence: [...#ResultEvidence] & [_, ...]

	min_stale_seconds?:      _|_
	stale_for_seconds?:      _|_
	timer_gate?:             _|_
	transcript_idle_age?:    _|_
	heartbeat?:              _|_
	scheduler?:              _|_
	daemon?:                 _|_
	durable_liveness_store?: _|_
	window_id?:              _|_
	pid?:                    _|_
	bd_defer?:               _|_
	bd_stale_release?:       _|_
	bd_orphans_fix?:         _|_
	jsonl_runtime_truth?:    _|_
	kitty_watcher?:          _|_
	kitty_env_state?:        _|_
	send_text_exit_proof?:   _|_
	codex_diagnostics?:      _|_
}

#ReclaimDiagnosis: {
	record_type:            "reclaim_diagnosis"
	task:                   #BeadsIssueID
	task_status:            "in_progress" | "hooked"
	assignee:               #NonEmpty
	agent_identity_source:  #ReclaimAgentIdentitySource
	expected_agent_address: #Address
	live_agent_match:       bool
	transcript:             #ReclaimTranscriptEvidence
	classification:         #ReclaimClassification
	evidence: [...#ResultEvidence] & [_, ...]

	if live_agent_match == true {
		classification: "live_agent_present"
	}
	if classification == "live_agent_present" {
		live_agent_match: true
	}
	if classification == "claimed_without_live_agent_transcript_backed" {
		live_agent_match: false
		transcript: {exists: true}
	}
	if classification == "claimed_without_live_agent_unfit" {
		live_agent_match: false
		transcript: {exists: false}
	}

	open_status?:              _|_
	closed_status?:            _|_
	deferred_status?:          _|_
	missing_assignee?:         _|_
	unknown_agent_name?:       _|_
	transcript_idle_age?:      _|_
	heartbeat?:                _|_
	scheduler?:                _|_
	daemon?:                   _|_
	durable_process_state?:    _|_
	persisted_window_id?:      _|_
	pid_liveness_authority?:   _|_
	send_text_delivery_proof?: _|_
}

#ReclaimDecision: {
	record_type: "reclaim_decision"
	task:        #BeadsIssueID
	diagnosis: #ReclaimDiagnosis & {task: task}
	action:  #ReclaimAction
	dry_run: bool | *true
	planned_commands: [...#ReclaimCommandEvidence]
	result_comment_required: true
	evidence: [...#ResultEvidence] & [_, ...]

	if action == "no_action" {
		diagnosis: {classification: "live_agent_present"}
		planned_commands: []
	}
	if action == "requeue_transcript_backed_work" {
		diagnosis: {classification: "claimed_without_live_agent_transcript_backed"}
		planned_commands: [
			#ReclaimCommandEvidence & {command: "bd update <task> --status open"},
			#ReclaimCommandEvidence & {command: "bd assign <task> \"\""},
			#ReclaimCommandEvidence & {command: "bd comments add <task> <message-or-file>"},
		]
	}
	if action == "operator_staleness_decision" {
		diagnosis: {classification: "claimed_without_live_agent_unfit"}
		tracking_bead: #BeadsIssueID
		planned_commands: [
			#ReclaimCommandEvidence & {command: "bd create <tracking-bead>"},
			#ReclaimCommandEvidence & {command: "bd comments add <tracking-bead> <message-or-file>"},
		]
	}

	min_stale_seconds?:      _|_
	stale_for_seconds?:      _|_
	transcript_idle_age?:    _|_
	release_claim?:          _|_
	timer_gate?:             _|_
	heartbeat?:              _|_
	scheduler?:              _|_
	daemon?:                 _|_
	durable_liveness_store?: _|_
	window_id?:              _|_
	pid?:                    _|_
	unverified_bd_command?:  _|_
}

#ReclaimSweepResult: {
	record_type:     "reclaim_sweep_result"
	policy:          #ReclaimPolicy
	source_snapshot: #WatchSnapshot | #MeshBeadsJoin
	decisions: [...#ReclaimDecision]
	wisp_surface: #ReclaimWispSurface
	result: #ResultEnvelope & {
		role: "implementation"
	}

	daemon?:                   _|_
	scheduler?:                _|_
	durable_store?:            _|_
	heartbeat?:                _|_
	window_id?:                _|_
	pid?:                      _|_
	transcript_idle_age?:      _|_
	yolo_default?:             _|_
	codex_diagnostics?:        _|_
	jsonl_runtime_truth?:      _|_
	send_text_delivery_proof?: _|_
}

#ResultEvidence: {
	kind:  #EvidenceKind
	label: #NonEmpty

	command?:        #NonEmpty
	path?:           #AbsPath
	ref?:            #NonEmpty
	exit_code?:      int
	output_excerpt?: string
}

#ImplementationResult: {
	kind:    "implementation"
	summary: #NonEmpty
	changed_files: [...#AbsPath]
	verification: [...#ResultEvidence] & [_, ...]
}

#ReviewFinding: {
	severity: "critical" | "high" | "medium" | "low"
	message:  #NonEmpty
	file?:    #AbsPath
	line?:    int & >0
}

#ReviewFindings: {
	kind:    "review_findings"
	summary: #NonEmpty
	findings: [...#ReviewFinding]
}

#Verdict: {
	kind:      "verdict"
	verdict:   "pass" | "fail"
	rationale: #NonEmpty
	evidence?: [...#ResultEvidence]
}

#ResultEnvelope: {
	record_type:       "result_envelope"
	task:              #BeadsIssueID
	session_id:        #SessionID
	address:           #Address
	status:            #ResultStatus
	completed_at_unix: int & >=0
	evidence: [...#ResultEvidence] & [_, ...]

	prose_only?: _|_
} & ({
	role:    "implementation"
	payload: #ImplementationResult
} | {
	role:    "reviewer"
	payload: #ReviewFindings
} | {
	role:    "judge"
	payload: #Verdict
} | {
	role:    "probe"
	payload: #Verdict
})

#GoalCheck: {
	kind: "command"
	cwd:  #AbsPath
	command: [...#NonEmpty] & [_, ...]
	expected_exit_code: int | *0
	side_effect_free:   true
	timeout_seconds?:   int & >0
}

#GoalAdversarialState: {
	label:           #NonEmpty
	reason:          #NonEmpty
	expected_status: "red"
}

#GoalPredicate: {
	record_type:          "goal_predicate"
	task:                 #BeadsIssueID
	description:          #NonEmpty
	frozen:               true
	red_check_required:   true
	close_requires_green: true
	check:                #GoalCheck
	adversarial: [...#GoalAdversarialState] & [_, ...]

	mutable?:       _|_
	scheduler?:     _|_
	durable_store?: _|_
	heartbeat?:     _|_
	...
}

#GoalEvaluation: {
	record_type:     "goal_evaluation"
	task:            #BeadsIssueID
	phase:           #GoalPhase
	status:          #GoalEvaluationStatus
	exit_code:       int
	checked_at_unix: int & >=0
	predicate: #GoalPredicate & {task: task}
	evidence: #ResultEvidence & {kind: "predicate"}
}

#GoalLoopStart: {
	record_type: "goal_loop_start"
	task:        #BeadsIssueID
	predicate: #GoalPredicate & {
		task:   task
		frozen: true
	}
	red_check: #GoalEvaluation & {
		task:   task
		phase:  "red-check"
		status: "red"
	}
}

#GoalLoopClose: {
	record_type: "goal_loop_close"
	task:        #BeadsIssueID
	predicate: #GoalPredicate & {task: task}
	close_evaluation: #GoalEvaluation & {
		task:   task
		phase:  "close"
		status: "green"
	}
	result: #ResultEnvelope & {
		task:   task
		status: "completed"
		evidence: [#ResultEvidence & {kind: "predicate"}, ...]
	}
}

#GoalLoopEscape: {
	record_type: "goal_loop_escape"
	task:        #BeadsIssueID
	predicate: #GoalPredicate & {task: task}
	last_evaluation: #GoalEvaluation & {task: task}
	reason: "iteration-budget-exhausted" | "wall-budget-exhausted" | "blocked"
	result: #ResultEnvelope & {
		task:   task
		status: "blocked" | "failed"
	}
}

#GoalDecomposition: {
	parent_task: #BeadsIssueID
	integration_predicate: #GoalPredicate & {
		task: parent_task
	}
	child_predicates: [...#GoalPredicate] & [_, ...]
}

#CompositionEvidenceCommand: {
	purpose:          #CompositionEvidencePurpose
	primitive:        #CompositionEvidencePrimitive
	command:          #NonEmpty
	side_effect_free: bool
	required:         true
	output_format:    #CompositionEvidenceOutputFormat
	result_ref?:      #NonEmpty
	exit_code?:       int
}

#CompositionEnvelopeEvidence: E={
	record_type:       "composition_envelope_evidence"
	source:            #CompositionEnvelopeSource
	task:              #BeadsIssueID
	exact_match_count: 1
	envelope: #ResultEnvelope & {
		task: E.task
	}
	evidence_command: #CompositionEvidenceCommand & {
		purpose:          "child-result-envelope" | "parent-integration-evaluation"
		side_effect_free: true
	}

	if source == "bd-comments-json" {
		evidence_command: {
			primitive:     "bd comments --json"
			output_format: "json"
		}
	}
	if source == "bd-show-json-include-comments" {
		evidence_command: {
			primitive:     "bd show --json --include-comments"
			output_format: "json"
		}
	}

	text_only_marker?: _|_
	wrong_task?:       _|_
	stale?:            _|_
	duplicate?:        _|_
	ambiguous?:        _|_
	prose_only?:       _|_
}

#RequiredChildClose: R={
	task: #BeadsIssueID
	predicate: #GoalPredicate & {
		task: R.task
	}
	close: #GoalLoopClose & {
		task:      R.task
		predicate: R.predicate
		result:    R.result
	}
	result: #ResultEnvelope & {
		task:   R.task
		status: "completed"
		evidence: [#ResultEvidence & {kind: "predicate"}, ...]
	}
	expected_result_payload?: #FormulaResultPayload
	formula_step?:            #FormulaStepID
	required:                 true
	envelope_evidence: #CompositionEnvelopeEvidence & {
		task: R.task
	}
} & ({
	expected_result_payload?: _|_
} | {
	expected_result_payload: "implementation"
	result: {
		role:    "implementation"
		payload: #ImplementationResult
	}
} | {
	expected_result_payload: "review_findings"
	result: {
		role:    "reviewer"
		payload: #ReviewFindings
	}
} | {
	expected_result_payload: "verdict"
	result: {
		role:    "judge" | "probe"
		payload: #Verdict
	}
})

#IntegrationPredicate: #GoalPredicate & {
	integration_scope:  #IntegrationScope
	composition_source: #CompositionSource
	proof_obligations: ["parent-predicate-distinct", #SourceSpecificIntegrationObligation, ...#IntegrationObligation]
	evidence_commands: [...#CompositionEvidenceCommand] & [_, ...]

	derived_from_child_conjunction?: _|_
	implicit_child_conjunction?:     _|_
	child_green_only?:               _|_
	implicit_parent_close?:          _|_
	prose_only?:                     _|_
	scheduler?:                      _|_
	durable_store?:                  _|_
	daemon?:                         _|_
	kitty_session?:                  _|_
	kitty_layout?:                   _|_
	kitty_watcher?:                  _|_
	codex_subagent_lifecycle?:       _|_
	provider?:                       _|_
	remote_provider?:                _|_
	secret_ref?:                     _|_
	credential?:                     _|_
}

#CompositionBond: {
	bond_type:    #CompositionBondType
	left:         #BeadsIssueID | #FormulaName
	right:        #BeadsIssueID | #FormulaName
	ref?:         #NonEmpty
	phase_policy: #CompositionBondPhasePolicy
	dry_run: #CompositionEvidenceCommand & {
		purpose:          "bond-shape"
		primitive:        "bd mol bond <A> <B> --dry-run"
		side_effect_free: true
	}

	hidden_child_ids?: _|_
	scheduler?:        _|_
	durable_store?:    _|_
}

#CompositionGateResume: {
	gate_required: true
	gate_type?:    #CompositionGateType
	gate_check: #CompositionEvidenceCommand & {
		primitive:        "bd gate check --dry-run"
		side_effect_free: true
	}
	ready_evidence: #CompositionEvidenceCommand & {
		purpose:          "gate-satisfaction"
		primitive:        "bd ready --gated --json" | "bd mol ready --json"
		side_effect_free: true
		output_format:    "json"
	}

	unresolved_gate?: _|_
}

#CompositionSwarm: {
	epic: #BeadsIssueID
	validate: #CompositionEvidenceCommand & {
		primitive:        "bd swarm validate <epic> --json"
		side_effect_free: true
		output_format:    "json"
	}
	status: #CompositionEvidenceCommand & {
		primitive:        "bd swarm status <epic> --json"
		side_effect_free: true
		output_format:    "json"
	}
	ready_fronts_accounted: true

	stored_swarm_status?: _|_
	scheduler?:           _|_
	durable_store?:       _|_
}

#CompositionFrontier: {
	command:            "bd ready --parent <epic> --exclude-type epic --json"
	epic:               #BeadsIssueID
	concurrency_cap:    int & >0
	planned_count:      int & >=0
	spawned_count:      int & >=0
	skipped_count:      int & >=0
	frontier_remaining: int & >=0
	records: [...#DispatchRecord]
}

#GoalComposition: C={
	record_type:        "goal_composition"
	parent_task:        #BeadsIssueID
	composition_source: #CompositionSource
	close_policy:       #CompositionClosePolicy | *"children-green-integration-green-and-result-envelope"
	integration_predicate: #IntegrationPredicate & {
		task: C.parent_task
	}
	child_tasks: [...#BeadsIssueID] & [_, ...]
	child_predicates: [...#GoalPredicate] & [_, ...]
	required_child_closes: [...#RequiredChildClose] & [_, ...]
	evidence_commands: [...#CompositionEvidenceCommand] & [_, ...]

	formula?:     #FormulaName
	molecule_id?: #BeadsIssueID
	bond?:        #CompositionBond
	gate_resume?: #CompositionGateResume
	swarm?:       #CompositionSwarm
	frontier?:    #CompositionFrontier

	if composition_source == "bd-formula" {
		formula: #FormulaName
		evidence_commands: [
			#CompositionEvidenceCommand & {
				primitive:        "bd formula list"
				side_effect_free: true
			},
			#CompositionEvidenceCommand & {
				primitive:        "bd mol wisp create <formula> --dry-run" | "bd mol pour <formula> --dry-run"
				side_effect_free: true
			},
			...#CompositionEvidenceCommand,
		]
	}
	if composition_source == "bd-mol" {
		molecule_id: #BeadsIssueID
		evidence_commands: [
			#CompositionEvidenceCommand & {
				primitive:        "bd mol show <molecule-id> --json" | "bd mol progress <molecule-id> --json" | "bd mol current <molecule-id> --json"
				side_effect_free: true
				output_format:    "json"
			},
			...#CompositionEvidenceCommand,
		]
	}
	if composition_source == "bd-mol-bond" {
		bond: #CompositionBond
	}
	if composition_source == "bd-mol-ready" {
		gate_resume: #CompositionGateResume
	}
	if composition_source == "bd-gate-resume" {
		gate_resume: #CompositionGateResume
	}
	if composition_source == "bd-swarm" {
		swarm: #CompositionSwarm
		evidence_commands: [
			#CompositionEvidenceCommand & {
				primitive:        "bd swarm validate <epic> --json"
				side_effect_free: true
				output_format:    "json"
			},
			#CompositionEvidenceCommand & {
				primitive:        "bd swarm status <epic> --json"
				side_effect_free: true
				output_format:    "json"
			},
			...#CompositionEvidenceCommand,
		]
	}
	if composition_source == "bd-ready-frontier" {
		frontier: #CompositionFrontier
		evidence_commands: [
			#CompositionEvidenceCommand & {
				primitive:        "bd ready --parent <epic> --exclude-type epic --json"
				side_effect_free: true
				output_format:    "json"
			},
			...#CompositionEvidenceCommand,
		]
	}

	derived_from_child_conjunction?: _|_
	implicit_parent_close?:          _|_
	child_green_only?:               _|_
	scheduler?:                      _|_
	durable_store?:                  _|_
	daemon?:                         _|_
	hidden_dispatch?:                _|_
	kitty_session?:                  _|_
	kitty_layout?:                   _|_
	kitty_watcher?:                  _|_
	codex_subagent_lifecycle?:       _|_
	provider?:                       _|_
	remote_provider?:                _|_
	secret_ref?:                     _|_
	credential?:                     _|_
}

#CompositionCloseout: C={
	record_type:  "composition_closeout"
	composition:  #GoalComposition
	child_closes: C.composition.required_child_closes
	integration_evaluation: #GoalEvaluation & {
		task:      C.composition.parent_task
		phase:     "close"
		status:    "green"
		predicate: C.composition.integration_predicate
	}
	result: #ResultEnvelope & {
		task:   C.composition.parent_task
		status: "completed"
		evidence: [#ResultEvidence & {kind: "predicate"}, ...]
	}
	close_policy: #CompositionClosePolicy | *"children-green-integration-green-and-result-envelope"
	verifier: #CompositionEvidenceCommand & {
		purpose:          "repository-verifier"
		primitive:        "./scripts/verify.sh"
		side_effect_free: true
	}

	child_green_only?:               _|_
	missing_integration_evaluation?: _|_
	prose_only?:                     _|_
	scheduler?:                      _|_
	durable_store?:                  _|_
	daemon?:                         _|_
}

#OfficialDocCitation: {
	source:            "OpenAI Codex manual"
	url:               #NonEmpty & =~"^https://developers\\.openai\\.com/codex/"
	section:           #NonEmpty
	manual_line_range: #NonEmpty
	fetched_by:        "openai-docs/fetch-codex-manual.mjs"
}

#CatalogCitation: {
	path:        "docs/catalog/README.md" | "docs/catalog/beads.md" | "docs/catalog/kitty.md" | "docs/catalog/codex.md" | "model/contract.cue" | "skills/codex-mesh/SKILL.md"
	line_range?: #NonEmpty
	reason:      #NonEmpty
}

#RequiredCookbookCatalogCitations: [
	#CatalogCitation & {path: "docs/catalog/README.md"},
	#CatalogCitation & {path: "docs/catalog/beads.md"},
	#CatalogCitation & {path: "docs/catalog/kitty.md"},
	#CatalogCitation & {path: "docs/catalog/codex.md"},
	(#CatalogCitation & {path: "model/contract.cue"}) | (#CatalogCitation & {path: "skills/codex-mesh/SKILL.md"}),
	...,
]

#RequiredCookbookOfficialDocs: [
	#OfficialDocCitation & {section: "goal-mode"},
	#OfficialDocCitation & {section: "model-guidance"},
	#OfficialDocCitation & {section: "sandbox-approval"},
	#OfficialDocCitation & {section: "agents-md"},
	#OfficialDocCitation & {section: "skills"},
	#OfficialDocCitation & {section: "mcp"},
	#OfficialDocCitation & {section: "noninteractive"},
	#OfficialDocCitation & {section: "subagents"},
	...,
]

#CodexModelPolicy: {
	recommended_model: "gpt-5.5"
	selected_model?:   #CodexModelID
	reasoning_effort?: #CodexReasoningEffort
	official_doc:      #OfficialDocCitation
}

#CodexSandboxPolicy: {
	sandbox_mode:       #CodexSandboxMode
	approval_policy:    #CodexApprovalPolicy
	full_access_bypass: bool | *false

	if full_access_bypass == false {
		sandbox_mode: "read-only" | "workspace-write"
	}
	if full_access_bypass == true {
		sandbox_mode:               "danger-full-access"
		approval_policy:            "never"
		isolated_worktree_required: true
		explicit_policy_reason:     #NonEmpty
	}
}

#CodexLaunchPolicy: {
	mode:         #CookbookLaunchMode
	sandbox:      #CodexSandboxPolicy
	model_policy: #CodexModelPolicy
	profile?:     #NonEmpty
	add_dirs?: [...#AbsPath]
	web_search?:            #CodexWebSearchMode
	mcp_health?:            "not-required" | "redacted-health-only"
	output_schema_required: bool | *false

	if mode == "interactive_kitty" {
		output_schema_required: false
		kitty_context:          #KittyContextResolution
		channel:                "spawn" | "tell" | "jump"
	}
	if mode == "noninteractive_exec" {
		output_schema_required: true
		channel:                "none"
	}
	if mode == "review" {
		output_schema_required:  true
		expected_result_payload: "review_findings"
		channel:                 "none"
	}

	remote_provider?:               _|_
	secret_ref?:                    _|_
	credential?:                    _|_
	private_origin?:                _|_
	raw_mcp_args?:                  _|_
	raw_mcp_env?:                   _|_
	yolo_default?:                  _|_
	closes_beads_directly?:         _|_
	send_text_exit_delivery_proof?: _|_
}

#CookbookContextSource: {
	surface:            #CookbookSurface
	ref:                #NonEmpty
	required:           bool | *true
	max_inline_bytes?:  int & >0
	redaction:          "none" | "secret-safe" | "credential-safe"
	snapshot_evidence?: #ResultEvidence

	if surface == "mcp_server" {
		redaction: "secret-safe" | "credential-safe"
	}
	if surface == "kitty_window" {
		durable_lifecycle?:  _|_
		window_id_as_state?: _|_
	}
	if surface == "native_subagent" {
		durable_lifecycle?: _|_
		lifecycle_owner?:   _|_
	}
}

#CookbookContextBundle: {
	sources: [...#CookbookContextSource] & [_, ...]
	allowed_surfaces: [...#CookbookSurface] & [_, ...]
	hydration_order: [...#CookbookSurface] & [_, ...]
	source_snapshots_required: true

	hidden_context_db?: _|_
	raw_mcp_inventory?: _|_
	credential?:        _|_
	token?:             _|_
	api_key?:           _|_
}

#CookbookStopRules: {
	close_policy:             #CookbookClosePolicyName
	red_check_required:       true
	close_requires_green:     true
	result_envelope_required: true
	retry_budget?:            int & >=0
	block_conditions: [...#NonEmpty] & [_, ...]
}

#CookbookRoleBundle: {
	role:                    #CookbookRole
	duty:                    #NonEmpty
	goal:                    #NonEmpty
	expected_result_payload: #CookbookResultPayload
	success_criteria:        #GoalPredicate
	context:                 #CookbookContextBundle
	launch_policy:           #CodexLaunchPolicy
	evidence_required: [...#EvidenceKind] & [_, ...]
	output_contract: #ResultEnvelope
	stop_rules:      #CookbookStopRules

	if role == "implementation" {
		expected_result_payload: "implementation"
		output_contract: {role: "implementation", payload: #ImplementationResult}
	}
	if role == "reviewer" {
		expected_result_payload: "review_findings"
		output_contract: {role: "reviewer", payload: #ReviewFindings}
	}
	if role == "judge" {
		expected_result_payload: "verdict"
		output_contract: {role: "judge", payload: #Verdict}
	}
	if role == "probe" {
		expected_result_payload: "verdict"
		output_contract: {role: "probe", payload: #Verdict}
	}

	prose_only?:             _|_
	unknown_payload?:        _|_
	success_criteria_prose?: _|_
	close_without_envelope?: _|_
}

#PromptRenderPolicy: {
	mode:             #PromptRenderMode & "goal-first"
	deterministic:    true
	side_effect_free: true
	message_template: string & =~"^/goal .+"
	include_sections: [...("role" | "goal" | "constraints" | "context" | "success_criteria" | "output_contract" | "stop_rules")] & [_, ...]
	preserve_transport_semantics: true
	source_snapshots_required:    true
	require_upfront_plan:         false | *false

	hidden_dispatch?:               _|_
	transport_mutation?:            _|_
	beads_lifecycle_mutation?:      _|_
	nondeterministic_order?:        _|_
	send_text_exit_delivery_proof?: _|_
}

#CookbookFixturePlan: {
	name:        #NonEmpty
	expectation: #CookbookFixtureExpectation
	cue_target:  "#ContextCookbook" | "#CookbookRoleBundle" | "#PromptRenderPolicy" | "#CodexLaunchPolicy"
	reason:      #NonEmpty
}

#CookbookVerifierPlan: {
	script: "./scripts/verify.sh"
	cue_vet_targets: ["#ContextCookbook", "#CookbookRoleBundle", "#PromptRenderPolicy", "#CodexLaunchPolicy", ...]
	valid_fixtures: [...#CookbookFixturePlan] & [_, ...]
	adversarial_fixtures: [...#CookbookFixturePlan] & [_, ...]
	drift_gate: "./scripts/verify.sh"
}

#CookbookCollapseTarget: {
	legacy_path: #NonEmpty
	replacement: #NonEmpty
	reason:      #NonEmpty
}

#CookbookRendererPlan: {
	adapter:                           "context-cookbook-renderer"
	reads_validated_cue:               true
	source_reads_only_before_dispatch: true
	emits_prompt_string:               true
	writes_result_envelope:            true
	allowed_invocations: ["mesh wave dispatch", "mesh workflow plan", "mesh workflow run", "spawn", "tell", "jump", "codex exec", "codex review", ...]
	forbidden: ["hidden worker dispatch", "new scheduler", "new durable state store", "raw mcp cache", "provider/auth management", ...]
}

#CookbookRenderedPrompt: {
	record_type: "cookbook_rendered_prompt"
	renderer:    "context-cookbook-renderer"
	cookbook_id: #CookbookID
	parent_task: #BeadsIssueID
	role:        #CookbookRole
	task:        #BeadsIssueID
	title:       #NonEmpty
	prompt_mode: #PromptRenderMode & "goal-first"
	message:     string & =~"^/goal .+"
	include_sections: [...("role" | "goal" | "constraints" | "context" | "success_criteria" | "output_contract" | "stop_rules")] & [_, ...]
	success_criteria:                  #GoalPredicate
	success_criteria_source:           "task-predicate" | "role-bundle"
	source_reads_only_before_dispatch: true
	preserve_transport_semantics:      true

	hidden_dispatch?:          _|_
	transport_mutation?:       _|_
	beads_lifecycle_mutation?: _|_
	durable_store?:            _|_
	scheduler?:                _|_
}

#CookbookDispatchEvidence: {
	record_type:                       "cookbook_dispatch_evidence"
	renderer:                          "context-cookbook-renderer"
	rendered_record_type:              "cookbook_rendered_prompt"
	cookbook_path:                     #AbsPath
	cookbook_id:                       #CookbookID
	parent_task:                       #BeadsIssueID
	role:                              #CookbookRole
	task:                              #BeadsIssueID
	source_reads_only_before_dispatch: true
	preserve_transport_semantics:      true
}

#ContextCookbook: {
	record_type:  "context_cookbook"
	cookbook_id:  #CookbookID
	parent_task:  #BeadsIssueID
	outcome_goal: #NonEmpty
	catalog_citations: [...#CatalogCitation] & #RequiredCookbookCatalogCitations
	official_docs: [...#OfficialDocCitation] & #RequiredCookbookOfficialDocs
	context_bundle: #CookbookContextBundle
	role_bundles: [...#CookbookRoleBundle] & [_, ...]
	launch_policy: #CodexLaunchPolicy
	model_policy:  #CodexModelPolicy
	render_policy: #PromptRenderPolicy
	close_policy:  #CookbookClosePolicyName
	verifier:      #CookbookVerifierPlan
	renderer_plan: #CookbookRendererPlan
	collapse_targets: [...#CookbookCollapseTarget]

	provider?:                  _|_
	remote_provider?:           _|_
	secret_ref?:                _|_
	credential?:                _|_
	private_origin?:            _|_
	hidden_scheduler?:          _|_
	durable_process_store?:     _|_
	raw_mcp_inventory?:         _|_
	plugin_runtime_required?:   _|_
	native_subagent_lifecycle?: _|_
	bd_jsonl_runtime_truth?:    _|_
	kitty_window_id_lifecycle?: _|_
	socket_scan?:               _|_
}

#WaveFrontierTask: {
	id:     #BeadsIssueID
	title:  #NonEmpty
	status: "open" | "in_progress" | "closed" | "blocked" | "hooked"
	parent: #BeadsIssueID

	assignee?: #NonEmpty
}

#WaveRequest: {
	record_type:      "wave_request"
	epic:             #BeadsIssueID
	role:             #Role
	address_prefix:   #Address
	concurrency_cap:  int & >0
	workdir:          #AbsPath
	prompt_mode:      #WavePromptMode
	message_template: string & =~"^/goal .+"
	frontier_command: #WaveFrontierCommand | *"bd ready --parent <epic> --exclude-type epic --json"
	dry_run:          bool | *false
	mutating:         bool | *false
	isolation: #IsolationPolicy | *{mode: "none"}
	cookbook?: {
		path:           #AbsPath
		role:           #CookbookRole
		predicate_dir?: #AbsPath
	}

	daemon?:        _|_
	scheduler?:     _|_
	durable_store?: _|_
	if mutating {
		isolation: {mode: "worktree"}
	}
}

#DispatchRecord: {
	record_type:    "dispatch_record"
	task:           #BeadsIssueID
	address:        #Address
	role:           #Role
	status:         #DispatchStatus
	message?:       #NonEmpty
	worktree_path?: #AbsPath
	cookbook?: #CookbookDispatchEvidence & {task: task}
} & ({
	status:      "planned"
	session_id?: _|_
	attachment?: _|_
} | {
	status:           "spawned"
	session_id:       #SessionID
	transcript_path?: #AbsPath
	attachment?: #SessionAttachment & {
		task:       task
		session_id: session_id
		address:    address
	}
} | {
	status:      "skipped"
	reason:      #DispatchSkipReason
	session_id?: _|_
	attachment?: _|_
})

#WaveStatus: {
	record_type: "wave_status"
	epic:        #BeadsIssueID
	request: #WaveRequest & {
		epic: epic
	}
	frontier_command: #WaveFrontierCommand
	frontier_source:  #WaveFrontierSource
	frontier: [...#WaveFrontierTask]
	spawned_count:      int & >=0 & <=request.concurrency_cap
	skipped_count:      int & >=0
	frontier_remaining: int & >=0
	records: [...#DispatchRecord]

	daemon?:        _|_
	scheduler?:     _|_
	durable_store?: _|_
}

#WatchCommand: {
	command:                "mesh watch"
	output_mode:            #WatchOutputMode | *"table"
	once:                   bool | *false
	include_detached:       bool | *false
	interval_seconds:       *2 | (int & >0)
	idle_threshold_seconds: *30 | (int & >=0)
	mesh_root?:             #AbsPath
	kitty_context?:         #KittyContextResolution
	workspace_scan_depth:   1 | *1

	durable_store?: _|_
	scheduler?:     _|_
	daemon?:        _|_
	token_budget?:  _|_
	dollar_budget?: _|_
}

#WatchWorkspace: {
	name:           #WorkspaceName
	root:           #AbsPath
	workspace_role: #WorkspaceRole | *"project"
	beads_status:   #BeadsWorkspaceStatus
	task_count:     int & >=0

	if workspace_role == "mesh-root" {
		beads_status: "available"
	}
} & ({
	beads_status: "available"
	error?:       _|_
} | {
	beads_status: "missing"
	task_count:   0
	error?:       _|_
} | {
	beads_status: "error"
	error:        #NonEmpty
} | {
	beads_status: "unknown"
	task_count:   0
	error?:       _|_
})

#WorkspaceDeclaration: {
	record_type!:    "workspace_declaration"
	name!:           #WorkspaceName
	kind!:           #WorkspaceKind
	workflow_class!: #WorkspaceWorkflowClass
	child!:          bool
	default_formulas?: [...#WorkspaceFormulaName] & [_, ...]

	if kind == "mesh" {
		workflow_class: "coordinator"
		child:          false
		default_formulas?: [...#WorkspaceFullFormulaName] & [_, ...]
	}
	if kind == "software-project" {
		workflow_class: "implementation"
		child:          true
		default_formulas?: [...#WorkspaceFullFormulaName] & [_, ...]
	}
	if kind == "notes" {
		workflow_class: "reference"
		child:          true
		default_formulas?: [...#WorkspaceReferenceFormulaName] & [_, ...]
	}

	root?:                _|_
	workspace_role?:      _|_
	beads_status?:        _|_
	bd_prefix?:           _|_
	database?:            _|_
	project_id?:          _|_
	repo_root?:           _|_
	beads_dir?:           _|_
	sync_remote?:         _|_
	remote_provider?:     _|_
	remote_url?:          _|_
	secret_ref?:          _|_
	credential?:          _|_
	private_origin?:      _|_
	provider_route?:      _|_
	op_ref?:              _|_
	token?:               _|_
	kitty_listen_on?:     _|_
	window_id?:           _|_
	pid?:                 _|_
	cwd?:                 _|_
	liveness?:            _|_
	durable_agent_state?: _|_
	scheduler?:           _|_
	daemon?:              _|_
	token_budget?:        _|_
	dollar_budget?:       _|_
}

#WorkspaceBeadsEvidence: {
	record_type!: "workspace_beads_evidence"
	status!:      #BeadsWorkspaceStatus
	source!:      "bd-config-context"
	commands!: [...#WorkspaceBeadsEvidenceCommand] & [_, ...]
	prefix?:      #BeadsPrefix
	database?:    #NonEmpty
	project_id?:  #NonEmpty
	repo_root?:   #AbsPath
	beads_dir?:   #AbsPath
	role?:        #NonEmpty
	sync_remote?: #NonEmpty

	if status == "available" {
		prefix: #BeadsPrefix
	}
	if status == "missing" {
		prefix?:      _|_
		database?:    _|_
		project_id?:  _|_
		repo_root?:   _|_
		beads_dir?:   _|_
		role?:        _|_
		sync_remote?: _|_
	}
	if status == "error" {
		prefix?: _|_
	}

	remote_provider?:      _|_
	remote_url_authority?: _|_
	remote_url?:           _|_
	secret_ref?:           _|_
	credential?:           _|_
	private_origin?:       _|_
	provider_route?:       _|_
	op_ref?:               _|_
	token?:                _|_
}

#Workspace: W={
	record_type!:    "workspace"
	name!:           #WorkspaceName
	root!:           #AbsPath
	workspace_role!: #WorkspaceRole
	kind!:           #WorkspaceKind
	workflow_class!: #WorkspaceWorkflowClass
	child!:          bool
	default_formulas!: [...#WorkspaceFormulaName] & [_, ...]
	declaration!: #WorkspaceDeclaration & {
		name:           W.name
		kind:           W.kind
		workflow_class: W.workflow_class
		child:          W.child
	}
	discovered!: #WatchWorkspace & {
		name:           W.name
		root:           W.root
		workspace_role: W.workspace_role
	}
	beads?: #WorkspaceBeadsEvidence

	if kind == "mesh" {
		workflow_class: "coordinator"
		child:          false
		workspace_role: "mesh-root"
		default_formulas: [...#WorkspaceFullFormulaName] & [_, ...]
		discovered: {
			workspace_role: "mesh-root"
			beads_status:   "available"
		}
		beads: {
			status: "available"
			prefix: #BeadsPrefix
		}
	}
	if kind == "software-project" {
		workflow_class: "implementation"
		child:          true
		workspace_role: "project"
		default_formulas: [...#WorkspaceFullFormulaName] & [_, ...]
		discovered: {
			workspace_role: "project"
			beads_status:   "available"
		}
		beads: {
			status: "available"
			prefix: #BeadsPrefix
		}
	}
	if kind == "notes" {
		workflow_class: "reference"
		child:          true
		workspace_role: "project"
		default_formulas: [...#WorkspaceReferenceFormulaName] & [_, ...]
		discovered: {
			workspace_role: "project"
			beads_status:   "missing" | "available"
		}
		if discovered.beads_status == "available" {
			beads: {
				status: "available"
				prefix: #BeadsPrefix
			}
		}
		if discovered.beads_status == "missing" {
			beads?: _|_
		}
	}

	bd_prefix?:           _|_
	remote_provider?:     _|_
	remote_url?:          _|_
	secret_ref?:          _|_
	credential?:          _|_
	private_origin?:      _|_
	provider_route?:      _|_
	op_ref?:              _|_
	token?:               _|_
	kitty_listen_on?:     _|_
	window_id?:           _|_
	pid?:                 _|_
	cwd?:                 _|_
	liveness?:            _|_
	cwd_liveness?:        _|_
	durable_agent_state?: _|_
	scheduler?:           _|_
	daemon?:              _|_
	token_budget?:        _|_
	dollar_budget?:       _|_
}

#WorkspaceValidationError: {
	code!:      #WorkspaceValidationCode
	message!:   #NonEmpty
	workspace?: #WorkspaceName
	root?:      #AbsPath
	command?:   #WorkspaceBeadsEvidenceCommand | #BeadsWorkspaceCommand | #WatchBeadsCommand
}

#WorkspaceValidation: {
	record_type!:          "workspace_validation"
	status!:               #WorkspaceValidationStatus
	workspace_scan_depth!: 1
	beads_command!:        #BeadsWorkspaceCommand
	mesh_root?:            #AbsPath
	workspaces!: [...#Workspace]
	errors!: [...#WorkspaceValidationError]

	if status == "valid" {
		errors: []
	}
	if status == "invalid" {
		errors: [_, ...]
	}

	_prefix_index: {
		for _, workspace in workspaces
		if workspace.discovered.beads_status == "available" {
			"\(workspace.beads.prefix)": workspace.name
		}
	}

	recursive_scan?: _|_
	durable_store?:  _|_
	scheduler?:      _|_
	daemon?:         _|_
	token_budget?:   _|_
	dollar_budget?:  _|_
}

#WatchSummary: {
	total:    int & >=0
	active:   int & >=0
	quiet:    int & >=0
	orphan:   int & >=0
	detached: int & >=0
}

#WatchRowBase: {
	record_type:       "watch_row"
	state:             #WatchState
	last_output_known: bool

	task_id?:           #BeadsIssueID
	task_title?:        #NonEmpty
	task_status?:       #BeadsJoinStatus
	workspace?:         #WorkspaceName
	workspace_root?:    #AbsPath
	beads_status?:      #BeadsWorkspaceStatus
	session_id?:        #SessionID
	window_id?:         int & >0
	address?:           #Address
	role?:              #Role
	cwd?:               #AbsPath
	transcript_path?:   #AbsPath
	transcript_exists?: bool
	transcript_bytes?:  int & >=0
	last_output_unix?:  int & >=0
	idle_seconds?:      int & >=0
	resume_signal?:     bool

	pid?:            _|_
	cmdline?:        _|_
	durable_store?:  _|_
	scheduler?:      _|_
	daemon?:         _|_
	token_budget?:   _|_
	dollar_budget?:  _|_
	inferred_state?: _|_
}

#WatchRow: #WatchRowBase & ({
	state:             "active"
	session_id:        #SessionID
	window_id:         int & >0
	address:           #Address
	task_id:           #BeadsIssueID
	task_status:       #BeadsJoinStatus
	cwd:               #AbsPath
	transcript_exists: true
	last_output_known: true
	idle_seconds:      int & >=0
} | {
	state:       "quiet"
	session_id:  #SessionID
	window_id:   int & >0
	address:     #Address
	task_id:     #BeadsIssueID
	task_status: #BeadsJoinStatus
	cwd:         #AbsPath
} | {
	state:        "orphan"
	session_id:   #SessionID
	window_id:    int & >0
	address:      #Address
	cwd:          #AbsPath
	task_status?: _|_
} | {
	state:              "detached"
	task_id:            #BeadsIssueID
	task_title:         #NonEmpty
	task_status:        #BeadsJoinStatus
	last_output_known:  false
	resume_signal:      bool
	session_id?:        _|_
	window_id?:         _|_
	address?:           _|_
	cwd?:               _|_
	transcript_path?:   _|_
	transcript_exists?: _|_
	transcript_bytes?:  _|_
	last_output_unix?:  _|_
	idle_seconds?:      _|_
})

#WatchSnapshot: {
	record_type:            "watch_snapshot"
	exposure:               "live-watch"
	source:                 #WatchSource
	generated_at_unix:      int & >=0
	idle_threshold_seconds: int & >=0
	include_detached:       bool | *false
	mesh_root?:             #AbsPath
	kitty_context?:         #KittyContextResolution
	workspace_scan_depth:   1
	beads_command:          #WatchBeadsCommand
	workspaces: [...#WatchWorkspace]
	rows: [...#WatchRow]
	summary: #WatchSummary
	if include_detached == false {
		rows: [...#WatchRow & {state: "active" | "quiet" | "orphan"}]
		summary: {detached: 0}
	}

	durable_store?:  _|_
	scheduler?:      _|_
	daemon?:         _|_
	token_budget?:   _|_
	dollar_budget?:  _|_
	recursive_scan?: _|_
}

#KittySessionLine: #NonEmpty & !~".*codex_.*" & !~".*--var(=| ).*" & !~".*set-user-vars.*" & !~".*--type=os-window.*" & !~".* codex( |$).*"

#KittySessionRenderCommand: {
	command:              "mesh session render"
	profile:              #SessionRenderProfile
	output_mode:          #SessionRenderOutputMode | *"session"
	source:               #SessionRenderSource | *"watch-snapshot"
	mesh_root?:           #AbsPath
	watch_snapshot?:      #AbsPath
	output_path?:         #AbsPath & =~".*\\.kitty-session$"
	workspace_scan_depth: 1 | *1

	durable_store?: _|_
	scheduler?:     _|_
	daemon?:        _|_
	token_budget?:  _|_
	dollar_budget?: _|_
	codex_addr?:    _|_
	codex_task?:    _|_
}

#KittySessionFile: {
	extension: ".kitty-session"
	lines: [...#KittySessionLine] & [_, ...]
	content: #NonEmpty
}

#KittySessionRender: {
	record_type: "kitty_session_render"
	profile:     #SessionRenderProfile
	source:      #SessionRenderSource
	command:     #KittySessionRenderCommand & {profile: profile, source: source}

	generated_at_unix:       int & >=0
	source_snapshot:         #WatchSnapshot
	session_file:            #KittySessionFile
	rendered_workspace_count: int & >=0
	rendered_agent_count:     int & >=0
	rendering_policy: {
		operator_scaffolding_only: true
		relaunches_agents:         false
		stores_live_agent_state:   false
		writes_durable_state:      false
		uses_codex_user_vars:      false
		session_file_keywords: [...("cd" | "new_tab" | "layout" | "launch")] & [_, ...]
	}

	durable_store?:      _|_
	scheduler?:          _|_
	daemon?:             _|_
	token_budget?:       _|_
	dollar_budget?:      _|_
	codex_addr?:         _|_
	codex_task?:         _|_
	codex_session?:      _|_
	codex_transcript?:   _|_
	user_vars?:          _|_
	window_liveness?:    _|_
	agent_state_store?:  _|_
	relaunches_agents?:  _|_
	remote_provider?:    _|_
	secret_ref?:         _|_
	credential?:         _|_
}

#IsolationPolicy: {
	mode: #IsolationMode
} & ({
	mode:           "none"
	worktree_base?: _|_
	worktree_path?: _|_
	cleanup?:       _|_
} | {
	mode:          "worktree"
	worktree_base: #AbsPath
	cleanup:       #WorktreeCleanup | *"remove-if-unchanged"
})

#WorktreePlan: {
	record_type:    "worktree_plan"
	address:        #Address
	source_workdir: #AbsPath
	worktree_base:  #AbsPath
	worktree_path:  #AbsPath
	command:        #WorktreeCommand
	cleanup:        #WorktreeCleanup
}

#WorkflowCommandSet: {
	side_effect_free:     bool
	mutates_repo_state:   bool | *false
	mutates_beads_state:  bool | *false
	mutates_git_metadata: bool | *false
}

#WorkflowBeadsCoordination: {
	task_claim_required: bool
	lifecycle_mutation:  bool | *false
	dependencies?: [...#BeadsIssueID]
	gate_required:       bool | *false
	merge_slot_required: bool | *false
}

#WorkflowPlacement: {
	repo_id:               #RepoID
	task_id:               #BeadsIssueID
	role:                  #Role
	cwd:                   #AbsPath
	placement_key:         #NonEmpty
	execution_mode:        #WorkflowExecutionMode
	isolation_mode:        #WorkflowIsolationMode
	communication_channel: #WorkflowChannel
	reason:                #NonEmpty
	command_set:           #WorkflowCommandSet
	beads:                 #WorkflowBeadsCoordination

	remote_provider?: _|_
	secret_ref?:      _|_
	credential?:      _|_
	private_origin?:  _|_
} & ({
	execution_mode:              "read_only"
	isolation_mode:              "shared_checkout"
	main_checkout_jurisdiction?: _|_
	command_set: {
		side_effect_free:     true
		mutates_repo_state:   false
		mutates_beads_state:  false
		mutates_git_metadata: false
	}
	beads: {
		lifecycle_mutation: false
	}
} | {
	execution_mode:              "read_only"
	isolation_mode:              "worktree"
	main_checkout_jurisdiction?: _|_
	command_set: {
		side_effect_free:     true
		mutates_repo_state:   false
		mutates_git_metadata: false
	}
} | {
	execution_mode:              "mutating"
	isolation_mode:              "worktree"
	main_checkout_jurisdiction?: _|_
	command_set: {
		side_effect_free:   false
		mutates_repo_state: true
	}
	beads: {
		task_claim_required: true
	}
} | {
	execution_mode:             "mutating"
	isolation_mode:             "main_owned"
	main_checkout_jurisdiction: true
	command_set: {
		side_effect_free:   false
		mutates_repo_state: true
	}
	beads: {
		task_claim_required: true
		merge_slot_required: true
	}
} | {
	execution_mode:             "merge"
	isolation_mode:             "main_owned"
	main_checkout_jurisdiction: true
	command_set: {
		side_effect_free:     false
		mutates_repo_state:   true
		mutates_git_metadata: true
	}
	beads: {
		task_claim_required: true
		merge_slot_required: true
	}
})

#WorkflowStepState: S={
	record_type:              "workflow_step_state"
	formula_step:             #FormulaStepID
	title:                    #NonEmpty
	status:                   #WorkflowStepStatus
	placement:                #WorkflowPlacement
	expected_result_payload:  #FormulaResultPayload
	expected_result_envelope: true
	close_policy:             "green-predicate-and-result-envelope"
	predicate_status?:        #GoalEvaluationStatus
	result?: #ResultEnvelope & {
		task: S.placement.task_id
	}

	if status == "closed" {
		predicate_status: "green"
		result: #ResultEnvelope & {
			task:   S.placement.task_id
			status: "completed"
		}
	}
	if status == "failed" {
		result: #ResultEnvelope & {
			task:   S.placement.task_id
			status: "failed"
		}
	}

	remote_provider?: _|_
	secret_ref?:      _|_
	credential?:      _|_
	private_origin?:  _|_
}

#RunnerDecision: D={
	record_type:           "runner_decision"
	step_id:               #FormulaStepID
	action:                #RunnerDecisionAction
	reason:                #NonEmpty
	visible_to_operator:   true
	communication_channel: #WorkflowChannel
	placement:             #WorkflowPlacement
	predicate_status?:     #GoalEvaluationStatus
	result?: #ResultEnvelope & {task: D.placement.task_id}

	remote_provider?: _|_
	secret_ref?:      _|_
	credential?:      _|_
	private_origin?:  _|_
} & ({
	action:                "dispatch"
	communication_channel: "spawn" | "tell" | "jump"
} | {
	action:                "close"
	communication_channel: "none"
	predicate_status:      "green"
	result: #ResultEnvelope & {
		task:   D.placement.task_id
		status: "completed"
	}
} | {
	action:                "wait"
	communication_channel: "none"
} | {
	action:                "block"
	communication_channel: "none"
} | {
	action:                "plan"
	communication_channel: "none"
})

#WorkflowLiveAuthorization: {
	record_type:                 "workflow_live_authorization"
	source:                      #WorkflowLiveAuthorizationSource | *"operator_gate"
	gate_id:                     #BeadsIssueID
	gate_status:                 #WorkflowLiveGateStatus
	scope:                       #WorkflowLiveScope
	project_gates_respected:     true
	worktree_isolation_required: true
	public_deployment_hold:      true
	max_running_agents:          int & >0 & <=10
	kill_switches: [...#WorkflowLiveKillSwitch] & ["lights_off", "broadcast_halt", ...]

	secret_ref?:         _|_
	credential?:         _|_
	remote_provider?:    _|_
	private_origin?:     _|_
	timer_release?:      _|_
	stale_timer?:        _|_
	daemon?:             _|_
	scheduler?:          _|_
	durable_store?:      _|_
	persisted_liveness?: _|_
}

#WorkflowLiveDispatchPolicy: P={
	record_type:                    "workflow_live_dispatch_policy"
	authorization:                  #WorkflowLiveAuthorization
	dry_run_default:                true
	live_requires_explicit_request: true
	concurrency_cap:                int & >0 & <=P.authorization.max_running_agents
	frontier_command:               #WorkflowLiveFrontierCommand
	spawn_adapter_reuse:            true
	spawn_adapter:                  #WorkflowLiveSpawnAdapter
	spawn_command:                  #WorkflowLiveSpawnCommand
	join_key:                       #WorkflowLiveJoinKey
	durable_state:                  #WorkflowLiveDurableState

	secret_ref?:          _|_
	credential?:          _|_
	remote_provider?:     _|_
	private_origin?:      _|_
	daemon?:              _|_
	scheduler?:           _|_
	durable_store?:       _|_
	persisted_liveness?:  _|_
	window_id_lifecycle?: _|_
}

#WorkflowLiveDispatchAttempt: A={
	record_type:   "workflow_live_dispatch_attempt"
	run_id:        #NonEmpty
	bounded_index: int & >=0
	decision: #RunnerDecision & {
		action:                "dispatch"
		communication_channel: "spawn"
		visible_to_operator:   true
		placement: {
			execution_mode: "mutating"
			isolation_mode: "worktree"
			beads: {
				task_claim_required: true
			}
		}
	}
	dispatch: #DispatchRecord & {
		task: A.decision.placement.task_id
		role: A.decision.placement.role
	}
	spawn_adapter_reuse: true
	spawn_adapter:       #WorkflowLiveSpawnAdapter
	spawn_command:       #WorkflowLiveSpawnCommand
	join_key:            #WorkflowLiveJoinKey

	daemon?:              _|_
	scheduler?:           _|_
	durable_store?:       _|_
	persisted_window_id?: _|_
	hidden_retry_state?:  _|_
}

#WorkflowLiveDispatchResult: R={
	record_type: "workflow_live_dispatch_result"
	run_id:      #NonEmpty
	policy:      #WorkflowLiveDispatchPolicy
	run: {
		record_type:   "workflow_run"
		command:       "mesh workflow"
		mode:          "run"
		run_id:        R.run_id
		dry_run:       false
		live_mutation: true
		request: #WorkflowRequest & {
			dry_run:       false
			live_mutation: true
		}
	}
	attempts: [...#WorkflowLiveDispatchAttempt & {run_id: R.run_id}] & [_, ...]
	spawned_count:      int & >=0 & <=R.policy.concurrency_cap
	skipped_count:      int & >=0
	frontier_remaining: int & >=0

	if frontier_remaining > 0 {
		skipped_count: int & >0
	}

	daemon?:             _|_
	scheduler?:          _|_
	durable_store?:      _|_
	persisted_liveness?: _|_
	hidden_dispatch?:    _|_
	provider?:           _|_
	remote_provider?:    _|_
	secret_ref?:         _|_
	credential?:         _|_
	private_origin?:     _|_
}

#WorkflowRequest: {
	record_type:            "workflow_request"
	formula:                #FormulaName
	parent_task:            #BeadsIssueID
	repo_id:                #RepoID
	workdir:                #AbsPath
	role:                   #Role | *"implementation"
	address_prefix:         #Address
	max_steps:              int & >0
	dry_run:                bool | *true
	live_mutation:          bool | *false
	default_execution_mode: #WorkflowExecutionMode | *"read_only"
	default_isolation_mode: #WorkflowIsolationMode | *"shared_checkout"
	worktree_base?:         #AbsPath
	result_envelopes?: [...#ResultEnvelope]
	live_authorization?:   #WorkflowLiveAuthorization
	live_dispatch_policy?: #WorkflowLiveDispatchPolicy

	if default_execution_mode == "mutating" {
		default_isolation_mode: "worktree" | "main_owned"
	}
	if default_execution_mode == "merge" {
		default_isolation_mode: "main_owned"
	}
	if default_isolation_mode == "worktree" {
		worktree_base: #AbsPath
	}

} & ({
	dry_run:               true
	live_mutation:         false
	live_authorization?:   _|_
	live_dispatch_policy?: _|_
} | {
	dry_run:            false
	live_mutation:      true
	live_authorization: #WorkflowLiveAuthorization
	live_dispatch_policy: #WorkflowLiveDispatchPolicy & {
		authorization: live_authorization
	}
	default_execution_mode: "mutating"
	default_isolation_mode: "worktree"
	worktree_base:          #AbsPath
}) & {
	remote_provider?: _|_
	secret_ref?:      _|_
	credential?:      _|_
	private_origin?:  _|_
}

#FormulaRun: F={
	record_type:  "formula_run"
	formula_name: #FormulaName
	parent_task:  #BeadsIssueID
	repo_id:      #RepoID
	workdir:      #AbsPath
	formula: #Formula & {
		formula: F.formula_name
	}
	steps: [...#WorkflowStepState] & [_, ...]
	result_envelopes?: [...#ResultEnvelope]

	remote_provider?: _|_
	secret_ref?:      _|_
	credential?:      _|_
	private_origin?:  _|_
}

#WorkflowRun: R={
	record_type:   "workflow_run"
	command:       "mesh workflow"
	mode:          #WorkflowRunMode
	run_id:        #NonEmpty
	status:        #WorkflowRunStatus
	bounded:       true
	dry_run:       R.request.dry_run
	live_mutation: R.request.live_mutation
	request:       #WorkflowRequest
	max_steps:     R.request.max_steps
	formula_run: #FormulaRun & {
		formula_name: R.request.formula
		parent_task:  R.request.parent_task
		repo_id:      R.request.repo_id
		workdir:      R.request.workdir
	}
	decisions: [...#RunnerDecision]
	live_dispatch_result?: #WorkflowLiveDispatchResult & {
		run_id: R.run_id
		run: {
			run_id:        R.run_id
			request:       R.request
			dry_run:       false
			live_mutation: true
		}
	}

	if mode == "plan" {
		status: "planned"
	}
	if mode == "run" {
		status: "running" | "blocked" | "completed" | "failed"
	}
	if live_mutation == true {
		mode:    "run"
		dry_run: false
		live_dispatch_result: #WorkflowLiveDispatchResult & {
			run_id: R.run_id
			run: {
				run_id:        R.run_id
				request:       R.request
				dry_run:       false
				live_mutation: true
			}
		}
	}

	remote_provider?: _|_
	secret_ref?:      _|_
	credential?:      _|_
	private_origin?:  _|_
	daemon?:          _|_
	scheduler?:       _|_
	durable_store?:   _|_
}

#FederationRole: {
	record_type: "federation_role"
	name:        #FederationRoleName
	scope:       #FederationRoleScope

	delegates_to_project_manager?:    bool
	direct_child_workspace_access?:   bool
	owns_cross_workspace_rollout?:    bool
	owns_one_project_workspace?:      bool
	owns_project_frontier?:           bool
	owns_worker_result_harvest?:      bool
	expected_result_payload?:         #FormulaResultPayload
	cross_workspace_lifecycle_owner?: bool
} & ({
	name:                            "coordinator"
	scope:                           "mesh-root"
	delegates_to_project_manager:    true
	direct_child_workspace_access:   false
	owns_cross_workspace_rollout:    true
	owns_one_project_workspace?:     _|_
	owns_project_frontier?:          _|_
	owns_worker_result_harvest?:     _|_
	expected_result_payload?:        _|_
	cross_workspace_lifecycle_owner: true
} | {
	name:                          "project-manager"
	scope:                         "project-workspace"
	owns_one_project_workspace:    true
	owns_project_frontier:         true
	owns_worker_result_harvest:    true
	direct_child_workspace_access: false
	expected_result_payload?:      _|_
} | {
	name:                    "implementation"
	scope:                   "project-workspace"
	expected_result_payload: "implementation"
} | {
	name:                    "reviewer"
	scope:                   "project-workspace"
	expected_result_payload: "review_findings"
} | {
	name:                    "judge" | "probe"
	scope:                   "project-workspace"
	expected_result_payload: "verdict"
})

#FederationWorkspaceRef: {
	record_type:                "federation_workspace_ref"
	workspace_id:               #WorkspaceName
	workspace_root:             #AbsPath
	workspace_role:             #WorkspaceRole
	workflow_class:             #WorkspaceWorkflowClass
	beads_prefix:               #BeadsPrefix
	beads_context_command:      "bd context --json" | "bd -C WORKSPACE context --json"
	mesh_root:                  #AbsPath
	belongs_to_lab_federation:  bool
	lab_root_context_proven?:   bool
	project_context_proven?:    bool
	workspace_identity_source?: "workspace-cue" | "beads-context" | "watch-snapshot"

	if workspace_role == "mesh-root" {
		workflow_class:            "coordinator"
		lab_root_context_proven:   true
		project_context_proven?:   _|_
		belongs_to_lab_federation: true
	}
	if workspace_role == "project" {
		workflow_class:            "implementation" | "reference"
		project_context_proven:    true
		belongs_to_lab_federation: true
	}

	recursive_scan?:          _|_
	provider?:                _|_
	remote_provider?:         _|_
	remote_url?:              _|_
	secret_ref?:              _|_
	credential?:              _|_
	private_origin?:          _|_
	global_database_assumed?: _|_
	persisted_liveness?:      _|_
	scheduler?:               _|_
	durable_store?:           _|_
}

#FederationCookbookBundle: {
	record_type:           "federation_cookbook_bundle"
	role:                  #FederationRoleName
	context_cookbook_id:   #CookbookID
	context_cookbook_path: #AbsPath
	handoff_surface:       #FederationHandoffSurface
	goal_predicate_path?:  #AbsPath
	role_bundle_role?:     #CookbookRole
	instruction_hydration: "fresh-agent-cwd-and-cookbook"

	if role == "implementation" {
		role_bundle_role: "implementation"
	}
	if role == "reviewer" {
		role_bundle_role: "reviewer"
	}
	if role == "judge" {
		role_bundle_role: "judge"
	}
	if role == "probe" {
		role_bundle_role: "probe"
	}
	if role == "coordinator" {
		role_bundle_role?: _|_
	}
	if role == "project-manager" {
		role_bundle_role?: _|_
	}

	raw_mcp_inventory?:     _|_
	provider?:              _|_
	remote_provider?:       _|_
	secret_ref?:            _|_
	credential?:            _|_
	private_origin?:        _|_
	native_subagent_state?: _|_
}

#FederationDelegation: {
	record_type:      "federation_delegation"
	source_mesh_task: #BeadsIssueID
	target_workspace: #FederationWorkspaceRef & {workspace_role: "project"}
	target_project_task: #BeadsIssueID
	coordinator: #FederationRole & {name: "coordinator"}
	project_manager: #FederationRole & {name: "project-manager"}
	transport:                                 #FederationTransport
	cookbook_bundle:                           #FederationCookbookBundle
	goal_predicate_path:                       #AbsPath
	expected_result:                           "federation_result_envelope"
	beads_comment_anchor:                      #NonEmpty
	transcript_required:                       true
	coordinator_direct_child_workspace_access: false
	workflow_existing_task_mapping_required:   bool | *false
	uses_hand_authored_molecule_child:         bool | *false
	uses_mesh_workflow_live_mode:              bool | *false
	live_authorization?:                       #WorkflowLiveAuthorization

	if uses_hand_authored_molecule_child {
		if uses_mesh_workflow_live_mode {
			workflow_existing_task_mapping_required: true
		}
	}

	routing_database?:            _|_
	second_task_db?:              _|_
	scheduler?:                   _|_
	durable_store?:               _|_
	persisted_window_id?:         _|_
	direct_child_workspace_edit?: _|_
	native_subagent_lifecycle?:   _|_
	federation_sync_scheduler?:   _|_
	secret_ref?:                  _|_
	credential?:                  _|_
	remote_provider?:             _|_
	private_origin?:              _|_
}

#FederationResultEnvelope: E={
	record_type: "federation_result_envelope"
	task:        #BeadsIssueID
	status:      #ResultStatus
	role:        #FederationResultRole
	base_envelope: #ResultEnvelope & {
		task:   E.task
		status: E.status
	}
	beads_comment_anchor: #NonEmpty
	transcript_paths: [...#AbsPath] & [_, ...]
} & ({
	role: "project-manager"
	workspace: #FederationWorkspaceRef & {workspace_role: "project"}
	delegated_results: [...#ResultEnvelope] & [_, ...]
	project_verifier:         #NonEmpty
	frontier_status:          #NonEmpty
	merge_slot_status:        #NonEmpty
	pushed_git_ref?:          #NonEmpty
	dolt_push_status?:        #NonEmpty
	pm_results?:              _|_
	lab_root_evidence?:       _|_
	cross_workspace_rollout?: _|_
} | {
	role: "coordinator"
	pm_results: [...#FederationResultEnvelope & {role: "project-manager"}] & [_, ...]
	lab_root_evidence:       #NonEmpty
	cross_workspace_rollout: true
	workspace?:              _|_
	delegated_results?:      _|_
	project_verifier?:       _|_
	frontier_status?:        _|_
	merge_slot_status?:      _|_
})

#FederationCapabilityRef: {
	record_type:            "federation_capability_ref"
	capability:             #NonEmpty
	provider:               #FederationCapabilityProvider
	dry_run_command:        "bd ship CAPABILITY --dry-run"
	export_label:           string & =~"^export:[A-Za-z0-9._-]+$"
	provides_label:         string & =~"^provides:[A-Za-z0-9._-]+$"
	external_dependency:    string & =~"^external:[A-Za-z0-9._-]+:[A-Za-z0-9._-]+$"
	public_deployment_hold: bool
	shipped:                bool | *false

	if public_deployment_hold == true {
		shipped: false
	}

	deployment_secret?:        _|_
	remote_provider_default?:  _|_
	automatic_public_publish?: _|_
	secret_ref?:               _|_
	credential?:               _|_
	private_origin?:           _|_
}

#FederationGateRef: {
	record_type:            "federation_gate_ref"
	gate_kind:              #FederationGateKind
	check_command:          "bd gate check --type=bead --dry-run"
	await_id:               #FederationGateAwaitPattern
	create_command_modeled: false
	reason:                 #NonEmpty

	gate_create_bead_assumption?: _|_
	hidden_timer?:                _|_
	stale_timer?:                 _|_
	provider_secret?:             _|_
	secret_ref?:                  _|_
	credential?:                  _|_
	private_origin?:              _|_
}

#FederationProjectManagerRun: R={
	record_type: "federation_project_manager_run"
	role: #FederationRole & {name: "project-manager"}
	workspace: #FederationWorkspaceRef & {workspace_role: "project"}
	source_delegation: #FederationDelegation & {
		target_workspace: R.workspace
	}
	worker_results: [...#ResultEnvelope] & [_, ...]
	project_verifier_command: #NonEmpty
	merge_slot_status:        #NonEmpty
	result: #FederationResultEnvelope & {
		role:      "project-manager"
		task:      R.source_delegation.target_project_task
		workspace: R.workspace
	}
}

#FederationRunRef: {
	record_type:            "federation_run_ref"
	task:                   #BeadsIssueID
	role:                   #FederationResultRole
	beads_comment_anchor:   #NonEmpty
	transcript_path:        #AbsPath
	result_envelope_target: "#FederationResultEnvelope"
}

#FederationCoordinatorRun: R={
	record_type: "federation_coordinator_run"
	role: #FederationRole & {name: "coordinator"}
	mesh_root_workspace: #FederationWorkspaceRef & {
		workspace_role: "mesh-root"
	}
	source_task: #BeadsIssueID
	delegations: [...#FederationDelegation] & [_, ...]
	result: #FederationResultEnvelope & {
		role: "coordinator"
		task: R.source_task
	}
	smoke?:                           #FederationSmoke
	no_direct_child_workspace_access: true

	direct_child_workspace_edit?: _|_
	routing_database?:            _|_
	scheduler?:                   _|_
	durable_store?:               _|_
}

#FederationSmoke: S={
	record_type:  "federation_smoke"
	request_task: #BeadsIssueID
	workspaces: [...#FederationWorkspaceRef] & [_, _, ...]
	coordinator_run: (#FederationCoordinatorRun & {
		source_task: S.request_task
	}) | (#FederationRunRef & {
		role: "coordinator"
		task: S.request_task
	})
	project_manager_runs: [...((#FederationProjectManagerRun) | (#FederationRunRef & {
		role: "project-manager"
	}))] & [_, _, ...]
	mesh_status_evidence: #NonEmpty
	mesh_watch_evidence:  #NonEmpty
	lab_root_beads_comments: [...#NonEmpty] & [_, ...]
	project_beads_comments: [...#NonEmpty] & [_, _, ...]
	transcript_paths: [...#AbsPath] & [_, _, ...]
	no_direct_coordinator_child_repo_edits: true

	direct_child_workspace_edit?: _|_
	routing_database?:            _|_
	scheduler?:                   _|_
	durable_store?:               _|_
	persisted_liveness?:          _|_
}

#FormulaGoal: {
	description:   #NonEmpty
	check:         #NonEmpty
	evidence_kind: #EvidenceKind | *"predicate"
}

#FormulaStepWaveHint: {
	prompt_mode: #WavePromptMode
	mutating:    bool | *false
	isolation: #IsolationPolicy | *{mode: "none"}
	if mutating {
		isolation: {mode: "worktree"}
	}
}

#FormulaStep: {
	id:          #FormulaStepID
	title:       #NonEmpty
	description: #NonEmpty
	type:        "task" | "bug" | "feature" | "epic" | "decision"
	priority:    int & >=0 & <=4
	depends_on?: [...#FormulaStepID]
	goal:           #FormulaGoal
	result_payload: #FormulaResultPayload
	wave?:          #FormulaStepWaveHint
}

#Formula: {
	formula:     #FormulaName
	description: #NonEmpty
	version:     int & >=1
	type:        #FormulaType
	phase?:      #FormulaPhase
	steps: [...#FormulaStep] & [_, ...]
}

#SpawnRequest: {
	command:        "spawn"
	backend:        #Backend
	address:        #Address
	role:           #Role | *"implementation"
	parent?:        #Address
	task?:          #BeadsIssueID
	workdir:        #AbsPath
	mesh_root?:     #AbsPath
	kitty_context?: #KittyContextResolution
	message?:       string
	transcript?:    #TranscriptPolicy
	isolation: #IsolationPolicy | *{mode: "none"}
	worktree_plan?: #WorktreePlan & {
		address:        address
		source_workdir: workdir
	}

	// Spawn creates a sibling/successor candidate but keeps the initiator alive.
	keep_parent: true
}

#TellRequest: {
	command:        "tell"
	backend:        #Backend
	target:         #Address
	mesh_root?:     #AbsPath
	kitty_context?: #KittyContextResolution
	message:        #NonEmpty
}

#TellResolution: {
	target: #Address
} & ({
	match_count: 1
	status:      "deliverable"
	window_id:   int & >0
	error?:      _|_
} | {
	match_count: 0
	status:      "blocked"
	error:       "zero-matches"
	window_id?:  _|_
} | {
	match_count: int & >1
	status:      "blocked"
	error:       "multiple-matches"
	window_id?:  _|_
})

#JumpRequest: {
	command:        "jump"
	backend:        #Backend
	successor:      #Address
	role:           #Role | *"successor"
	task?:          #BeadsIssueID
	workdir:        #AbsPath
	mesh_root?:     #AbsPath
	kitty_context?: #KittyContextResolution
	message?:       string
	transcript?:    #TranscriptPolicy
	isolation: #IsolationPolicy | *{mode: "none"}
	worktree_plan?: #WorktreePlan & {
		address:        successor
		source_workdir: workdir
	}

	// Jump is a handoff. It is not a synonym for spawn.
	keep_parent: false
}

#AddressPreflight: {
	address: #Address
} & ({
	match_count: 0
	status:      "launchable"
	error?:      _|_
	window_id?:  _|_
} | {
	match_count: int & >0
	status:      "blocked"
	error:       "address-already-running"
	window_id?:  _|_
})

#JumpResult: {
	successor: #Address
} & ({
	status:              "ready-to-close-parent"
	successor_confirmed: true
	window_id:           int & >0
} | {
	status:              "blocked"
	successor_confirmed: false
	error:               "launch-failed" | "successor-not-found" | "successor-ambiguous"
	window_id?:          _|_
})
