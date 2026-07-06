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

#CurrentBeadsPrimitive: "bd ready" | "bd ready --json" | "bd ready --parent <epic> --exclude-type epic --json" | "bd show" | "bd update --claim" | "bd assign" | "bd comment" | "bd comments" | "bd note" | "bd list --status=open,in_progress,hooked --json" | "bd -C <workspace> list --status=open,in_progress,hooked --json" | "bd swarm" | "bd swarm validate <epic> --json" | "bd swarm status <epic> --json" | "bd gate" | "bd gate check --dry-run" | "bd merge-slot" | "bd merge-slot check" | "bd merge-slot acquire --holder <holder>" | "bd merge-slot release --holder <holder>" | "bd repo" | "bd mol" | "bd formula list"
#BeadsStatusCommand:    "bd list --status=open,in_progress,hooked --json"
#BeadsWorkspaceCommand: "bd -C <workspace> list --status=open,in_progress,hooked --json"
#WatchBeadsCommand:     #BeadsStatusCommand | #BeadsWorkspaceCommand
#BeadsJoinStatus:       "open" | "in_progress" | "hooked"
#ResultStatus:          "completed" | "blocked" | "failed"
#EvidenceKind:          "command" | "file" | "transcript" | "beads" | "predicate"
#GoalPhase:             "red-check" | "iteration" | "close"
#GoalEvaluationStatus:  "red" | "green"
#WaveFrontierCommand:   "bd ready --parent <epic> --exclude-type epic --json"
#WavePromptMode:        "goal-first"
#WaveFrontierSource:    "live-bd" | "fixture"
#DispatchStatus:        "planned" | "spawned" | "skipped"
#DispatchSkipReason:    "cap-reached" | "not-ready" | "already-live" | "spawn-failed"
#IsolationMode:         "none" | "worktree"
#WorktreeCleanup:       "remove-if-unchanged" | "manual"
#WorktreeCommand:       "git worktree add --detach <path> HEAD"
#RepoID:                string & =~"^[A-Za-z0-9._/-]+$"
#WorkflowRunMode:       "plan" | "run" | "status"
#WorkflowRunStatus:     "planned" | "running" | "blocked" | "completed" | "failed"
#WorkflowStepStatus:    "blocked" | "ready" | "running" | "closed" | "failed" | "skipped"
#WorkflowExecutionMode: "read_only" | "mutating" | "merge"
#WorkflowIsolationMode: "shared_checkout" | "worktree" | "main_owned"
#WorkflowChannel:       "spawn" | "tell" | "jump" | "none"
#RunnerDecisionAction:  "plan" | "dispatch" | "wait" | "close" | "block"
#WatchState:            "active" | "quiet" | "orphan" | "detached"
#WatchSource:           "live" | "fixture"
#WatchOutputMode:       "table" | "json" | "ndjson"
#KittyContextSource:    "mesh-root-config" | "env" | "current-kitty" | "fixture"
#WorkspaceName:         string & =~"^[A-Za-z0-9._-]+$"
#WorkspaceRole:         "mesh-root" | "project"
#BeadsWorkspaceStatus:  "available" | "missing" | "error" | "unknown"
#RemoteSource:          "operator-config"
#FormulaName:           string & =~"^[a-z][a-z0-9-]{1,63}$"
#SoloException:         "conversational-reply" | "single-read-lookup" | "trivial-mechanical-edit" | "emergency-transport-recovery"
#OrchestrationDispatch: "mesh wave dispatch" | "mesh workflow run"
#FormulaStepID:         string & =~"^[a-z][a-z0-9-]{1,63}$"
#FormulaType:           "workflow"
#FormulaPhase:          "solid" | "liquid" | "vapor"
#FormulaResultPayload:  "implementation" | "review_findings" | "verdict"
#InstallDependencyName: "bash" | "python3" | "jq" | "git" | "bd" | "kitty" | "codex" | "cue"
#InstallDependencyUse:  "runtime" | "verification"
#InstallDependencyStatus: "found" | "missing"

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

// The operating posture, not a command: substantive work defaults to
// formula-driven orchestration; solo execution must name its exception.
#OrchestrationDefault: {
	record_type:                   "orchestration_default"
	default_mode:                  "workflow"
	solo_requires_named_exception: true
	solo_exceptions: [...#SoloException] & [_, ...]

	decomposition: "beads-formula"
	dispatch:      #OrchestrationDispatch
	close_policy:  "green-predicate-and-result-envelope"
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

		private_origin?:               _|_
		remote_provider?:              _|_
		secret_ref?:                   _|_
		credential?:                   _|_
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
		private_authority:          false
		private_launch_support:     false
		operator_provisioning:      false
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
			secret_ref:                  "model/fixtures/invalid-public-core-secret-ref.json"
			private_plugin_in_core:      "model/fixtures/invalid-public-core-private-plugin-in-core.json"
			missing_operator_session_logs: "model/fixtures/invalid-public-core-missing-operator-session-logs.json"
			workflow_authority:          "model/fixtures/invalid-public-core-workflow-authority.json"
			formula_dry_runs_missing:    "model/fixtures/invalid-public-core-formula-dry-runs-missing.json"
		}
	}

	private_origin?:          _|_
	remote_provider?:         _|_
	secret_ref?:              _|_
	credential?:              _|_
	op_ref?:                  _|_
	token?:                   _|_
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
	side_effect_free:    bool
	mutates_repo_state:  bool | *false
	mutates_beads_state: bool | *false
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
	execution_mode: "read_only"
	isolation_mode: "shared_checkout"
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
	execution_mode: "read_only"
	isolation_mode: "worktree"
	main_checkout_jurisdiction?: _|_
	command_set: {
		side_effect_free:     true
		mutates_repo_state:   false
		mutates_git_metadata: false
	}
} | {
	execution_mode: "mutating"
	isolation_mode: "worktree"
	main_checkout_jurisdiction?: _|_
	command_set: {
		side_effect_free:   false
		mutates_repo_state: true
	}
	beads: {
		task_claim_required: true
	}
} | {
	execution_mode: "mutating"
	isolation_mode: "main_owned"
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
	execution_mode: "merge"
	isolation_mode: "main_owned"
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
	expected_result_payload:   #FormulaResultPayload
	expected_result_envelope:  true
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
	record_type:         "runner_decision"
	step_id:             #FormulaStepID
	action:              #RunnerDecisionAction
	reason:              #NonEmpty
	visible_to_operator: true
	communication_channel: #WorkflowChannel
	placement:             #WorkflowPlacement
	predicate_status?:      #GoalEvaluationStatus
	result?:                #ResultEnvelope & {task: D.placement.task_id}

	remote_provider?: _|_
	secret_ref?:      _|_
	credential?:      _|_
	private_origin?:  _|_
} & ({
	action: "dispatch"
	communication_channel: "spawn" | "tell" | "jump"
} | {
	action: "close"
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

#WorkflowRequest: {
	record_type:     "workflow_request"
	formula:         #FormulaName
	parent_task:     #BeadsIssueID
	repo_id:         #RepoID
	workdir:         #AbsPath
	role:            #Role | *"implementation"
	address_prefix:  #Address
	max_steps:       int & >0
	dry_run:         true | *true
	live_mutation:   false | *false
	default_execution_mode: #WorkflowExecutionMode | *"read_only"
	default_isolation_mode: #WorkflowIsolationMode | *"shared_checkout"
	worktree_base?:  #AbsPath
	result_envelopes?: [...#ResultEnvelope]

	if default_execution_mode == "mutating" {
		default_isolation_mode: "worktree" | "main_owned"
	}
	if default_execution_mode == "merge" {
		default_isolation_mode: "main_owned"
	}
	if default_isolation_mode == "worktree" {
		worktree_base: #AbsPath
	}

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
	dry_run:       true
	live_mutation: false
	request:       #WorkflowRequest
	max_steps:     R.request.max_steps
	formula_run: #FormulaRun & {
		formula_name: R.request.formula
		parent_task:  R.request.parent_task
		repo_id:      R.request.repo_id
		workdir:      R.request.workdir
	}
	decisions: [...#RunnerDecision]

	if mode == "plan" {
		status: "planned"
	}
	if mode == "run" {
		status: "running" | "blocked" | "completed" | "failed"
	}

	remote_provider?: _|_
	secret_ref?:      _|_
	credential?:      _|_
	private_origin?:  _|_
	daemon?:          _|_
	scheduler?:       _|_
	durable_store?:   _|_
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
