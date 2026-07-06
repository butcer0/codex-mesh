#!/usr/bin/env bash

codex_mesh_die() {
	printf '%s\n' "$*" >&2
	exit 1
}

codex_mesh_need() {
	command -v "$1" >/dev/null 2>&1 || codex_mesh_die "codex-mesh: missing required command: $1"
}

codex_mesh_script_dir() {
	local src="${BASH_SOURCE[0]}"
	while [[ -L "$src" ]]; do
		local dir
		dir="$(cd -P "$(dirname "$src")" >/dev/null 2>&1 && pwd)"
		src="$(readlink "$src")"
		[[ "$src" == /* ]] || src="$dir/$src"
	done
	cd -P "$(dirname "$src")" >/dev/null 2>&1 && pwd
}

codex_mesh_join_message() {
	if (($# == 0)); then
		return 1
	fi
	local message="$1"
	shift
	local word
	for word in "$@"; do
		message+=" $word"
	done
	printf '%s\n' "$message"
}

codex_mesh_default_addr() {
	local role="$1"
	printf 'codex-%s-%s-%s\n' "$role" "$(date -u +%Y%m%d%H%M%S)" "$$"
}

codex_mesh_validate_addr() {
	[[ "$1" =~ ^[a-z][a-z0-9-]{1,63}$ ]] || codex_mesh_die "codex-mesh: invalid address: $1"
}

codex_mesh_validate_role() {
	[[ "$1" =~ ^[a-z][a-z0-9-]{1,31}$ ]] || codex_mesh_die "codex-mesh: invalid role: $1"
}

codex_mesh_validate_task() {
	[[ "$1" =~ ^[a-z][a-z0-9]*-[a-z0-9]+(-[a-z0-9]+)*(\.[0-9]+)*$ ]] || codex_mesh_die "codex-mesh: invalid beads task id: $1"
}

codex_mesh_validate_isolation() {
	case "$1" in
	none|worktree)
		return 0
		;;
	*)
		codex_mesh_die "codex-mesh: invalid isolation mode: $1"
		;;
	esac
}

codex_mesh_default_worktree_base() {
	if [[ -n "${CODEX_MESH_WORKTREE_DIR:-}" ]]; then
		printf '%s\n' "$CODEX_MESH_WORKTREE_DIR"
	else
		printf '%s\n' "${XDG_STATE_HOME:-$HOME/.local/state}/codex-mesh/worktrees"
	fi
}

codex_mesh_worktree_path() {
	local addr="$1" base="$2"
	codex_mesh_validate_addr "$addr"
	[[ "$base" == /* ]] || codex_mesh_die "codex-mesh: worktree base must be an absolute path: $base"
	printf '%s/%s\n' "${base%/}" "$addr"
}

codex_mesh_prepare_worktree() {
	local source_workdir="$1" worktree_path="$2"
	codex_mesh_need git
	[[ "$source_workdir" == /* ]] || codex_mesh_die "codex-mesh: source workdir must be absolute: $source_workdir"
	[[ "$worktree_path" == /* ]] || codex_mesh_die "codex-mesh: worktree path must be absolute: $worktree_path"
	[[ ! -e "$worktree_path" ]] || codex_mesh_die "codex-mesh: worktree path already exists: $worktree_path"
	mkdir -p "$(dirname "$worktree_path")"
	git -C "$source_workdir" worktree add --detach "$worktree_path" HEAD >/dev/null
}

codex_mesh_transcript_dir() {
	local addr="$1"
	codex_mesh_validate_addr "$addr"
	if [[ "${CODEX_MESH_TRANSCRIPT_DISABLE:-}" == "1" ]]; then
		return 0
	fi

	local base_dir
	if [[ -n "${CODEX_MESH_TRANSCRIPT_DIR:-}" ]]; then
		base_dir="$CODEX_MESH_TRANSCRIPT_DIR"
	else
		base_dir="${XDG_STATE_HOME:-$HOME/.local/state}/codex-mesh/transcripts"
	fi
	mkdir -p "$base_dir"
	chmod 700 "$base_dir"
	printf '%s\n' "$base_dir"
}

codex_mesh_abs_dir() {
	local path="$1"
	[[ -d "$path" ]] || codex_mesh_die "codex-mesh: directory does not exist: $path"
	cd "$path" >/dev/null 2>&1 && pwd -P
}

codex_mesh_context_command() {
	local script
	script="$(codex_mesh_script_dir)/codex-mesh-context"
	[[ -x "$script" ]] || codex_mesh_die "codex-mesh: context helper is not executable: $script"
	printf '%s\n' "$script"
}

codex_mesh_kitty_context_json() {
	local mesh_root="${1:-}" cwd="${2:-$PWD}" script
	script="$(codex_mesh_context_command)"
	if [[ -n "${CODEX_MESH_KITTY_LS_FILE:-}" ]]; then
		python3 - "$mesh_root" "$cwd" <<'PY'
import json
import os
import sys

mesh_root, cwd = sys.argv[1], sys.argv[2]
payload = {
    "record_type": "kitty_context_resolution",
    "source": "fixture",
    "cwd": os.path.abspath(cwd),
}
if mesh_root:
    payload["mesh_root"] = os.path.abspath(mesh_root)
json.dump(payload, sys.stdout, indent=2, sort_keys=True)
print()
PY
		return
	fi
	if [[ -n "$mesh_root" ]]; then
		"$script" resolve --cwd "$cwd" --mesh-root "$mesh_root" --json
	else
		"$script" resolve --cwd "$cwd" --json
	fi
}

codex_mesh_resolve_kitty_listen_on() {
	local mesh_root="${1:-}" cwd="${2:-$PWD}" script
	script="$(codex_mesh_context_command)"
	if [[ -n "$mesh_root" ]]; then
		"$script" resolve --cwd "$cwd" --mesh-root "$mesh_root" | awk -F= '$1 == "kitty_listen_on" {print substr($0, index($0, "=") + 1); exit}'
	else
		"$script" resolve --cwd "$cwd" | awk -F= '$1 == "kitty_listen_on" {print substr($0, index($0, "=") + 1); exit}'
	fi
}

codex_mesh_kitty_ls() {
	local mesh_root="${1:-}" cwd="${2:-$PWD}" listen_on
	if [[ -n "${CODEX_MESH_KITTY_LS_FILE:-}" ]]; then
		cat "$CODEX_MESH_KITTY_LS_FILE"
		return
	fi
	listen_on="$(codex_mesh_resolve_kitty_listen_on "$mesh_root" "$cwd")"
	if [[ -n "$listen_on" ]]; then
		kitty @ --to "$listen_on" ls
	else
		kitty @ ls
	fi
}

codex_mesh_bd_status_snapshot() {
	if [[ -n "${CODEX_MESH_BD_LIST_FILE:-}" ]]; then
		cat "$CODEX_MESH_BD_LIST_FILE"
		return
	fi
	bd list --status=open,in_progress,hooked --json
}

codex_mesh_resolve_addr() {
	local addr="$1" mesh_root="${2:-}" cwd="${3:-$PWD}"
	codex_mesh_validate_addr "$addr"
	codex_mesh_need jq

	codex_mesh_kitty_ls "$mesh_root" "$cwd" | jq -r --arg addr "$addr" '
		[
			.[].tabs[].windows[]
			| select(.user_vars.codex_addr? == $addr)
			| .id
		] as $ids
		| if ($ids | length) == 1 then
			"ok " + ($ids[0] | tostring)
		elif ($ids | length) == 0 then
			"zero"
		else
			"multiple " + (($ids | length) | tostring)
		end
	'
}

codex_mesh_confirm_addr() {
	local addr="$1" expected_id="${2:-}" mesh_root="${3:-}" cwd="${4:-$PWD}" attempt resolved status id
	for attempt in {1..20}; do
		resolved="$(codex_mesh_resolve_addr "$addr" "$mesh_root" "$cwd")"
		status="${resolved%% *}"
		if [[ "$status" == "ok" ]]; then
			id="${resolved#ok }"
			if [[ -z "$expected_id" || "$id" == "$expected_id" ]]; then
				printf '%s\n' "$id"
				return 0
			fi
		fi
		sleep 0.1
	done
	return 1
}

codex_mesh_require_addr_available() {
	local addr="$1" mesh_root="${2:-}" cwd="${3:-$PWD}" resolved status
	codex_mesh_validate_addr "$addr"
	if [[ "${CODEX_MESH_DRY_RUN:-}" == "1" && -z "${CODEX_MESH_KITTY_LS_FILE:-}" ]]; then
		return 0
	fi

	resolved="$(codex_mesh_resolve_addr "$addr" "$mesh_root" "$cwd")"
	status="${resolved%% *}"
	case "$status" in
	zero)
		return 0
		;;
	ok)
		codex_mesh_die "codex-mesh: address already running: $addr (window_id=${resolved#ok })"
		;;
	multiple)
		codex_mesh_die "codex-mesh: address already running: $addr (${resolved#multiple } matches)"
		;;
	*)
		codex_mesh_die "codex-mesh: could not preflight address: $addr"
		;;
	esac
}

codex_mesh_send_prompt_to_window() {
	local window_id="$1" message="$2" mesh_root="${3:-}" cwd="${4:-$PWD}" listen_on
	listen_on="$(codex_mesh_resolve_kitty_listen_on "$mesh_root" "$cwd")"
	if [[ -n "$listen_on" ]]; then
		printf '%s\n' "$message" | kitty @ --to "$listen_on" send-text --match "id:$window_id" --bracketed-paste=enable --stdin
		kitty @ --to "$listen_on" send-text --match "id:$window_id" '\r'
	else
		printf '%s\n' "$message" | kitty @ send-text --match "id:$window_id" --bracketed-paste=enable --stdin
		kitty @ send-text --match "id:$window_id" '\r'
	fi
}

codex_mesh_spawn_codex() {
	local addr="$1" role="$2" parent="$3" task="$4" title="$5" workdir="$6" transcript_dir="$7" mesh_root="${8:-}" context_cwd="${9:-$workdir}" message="${10:-}" listen_on
	listen_on="$(codex_mesh_resolve_kitty_listen_on "$mesh_root" "$context_cwd")"
	local kitty_args=()
	[[ -n "$listen_on" ]] && kitty_args+=(--to "$listen_on")
	kitty_args+=(
		launch
		--type=os-window
		--hold
		--title "$title"
		--var "codex_addr=$addr"
		--var "codex_role=$role"
		--cwd "$workdir"
	)
	[[ -n "$parent" ]] && kitty_args+=(--var "codex_parent=$parent")
	[[ -n "$task" ]] && kitty_args+=(--var "codex_task=$task")
	kitty_args+=(--env "CODEX_ADDR=$addr")
	kitty_args+=(--env "CODEX_ROLE=$role")
	[[ -n "$parent" ]] && kitty_args+=(--env "CODEX_PARENT=$parent")
	[[ -n "$task" ]] && kitty_args+=(--env "CODEX_TASK=$task")
	[[ -n "$mesh_root" ]] && kitty_args+=(--env "CODEX_MESH_ROOT=$mesh_root")
	[[ -n "$transcript_dir" ]] && kitty_args+=(--env "CODEX_MESH_TRANSCRIPT_DIR=$transcript_dir")
	[[ -n "$listen_on" ]] && kitty_args+=(--env "KITTY_LISTEN_ON=$listen_on")
	[[ -n "${KITTY_PUBLIC_KEY:-}" ]] && kitty_args+=(--env "KITTY_PUBLIC_KEY=$KITTY_PUBLIC_KEY")

	local recorder=""
	if [[ -n "$transcript_dir" ]]; then
		codex_mesh_need python3
		recorder="$(codex_mesh_script_dir)/codex-mesh-record"
		[[ -x "$recorder" ]] || codex_mesh_die "codex-mesh: transcript recorder is not executable: $recorder"
		kitty_args+=(--env "CODEX_MESH_RECORDER=$recorder")
	fi

	if [[ "${CODEX_MESH_DRY_RUN:-}" == "1" ]]; then
		printf '%s\n' "${CODEX_MESH_DRY_RUN_WINDOW_ID:-dry-run}"
		return 0
	fi

	if [[ -n "$message" ]]; then
		kitty @ "${kitty_args[@]}" bash -lc 'if [[ -n "${CODEX_MESH_TRANSCRIPT_DIR:-}" ]]; then exec "$CODEX_MESH_RECORDER" "$CODEX_MESH_TRANSCRIPT_DIR" codex --yolo "$@"; else exec codex --yolo "$@"; fi' codex "$message"
	else
		kitty @ "${kitty_args[@]}" bash -lc 'if [[ -n "${CODEX_MESH_TRANSCRIPT_DIR:-}" ]]; then exec "$CODEX_MESH_RECORDER" "$CODEX_MESH_TRANSCRIPT_DIR" codex --yolo "$@"; else exec codex --yolo "$@"; fi' codex
	fi
}
