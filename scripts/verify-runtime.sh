#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

need() {
	command -v "$1" >/dev/null 2>&1 || {
		echo "verify-runtime: missing required command: $1" >&2
		exit 1
	}
}

need bash
need cue
need jq
need bd

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT
bd formula list >"$TMPDIR/formula-list.txt"
for formula in cue-first-feature review-wave judge-panel loop-until-dry completeness-critic; do
	cue vet ".beads/formulas/$formula.formula.json" model/contract.cue -d '#Formula'
	grep -q "  $formula " "$TMPDIR/formula-list.txt"
	bd mol wisp create "$formula" --dry-run >/dev/null
done
bd mol pour cue-first-feature --dry-run >/dev/null
bd ready --gated --json | jq -e '.schema_version >= 1 and has("count")' >/dev/null
bd gate check --dry-run --json >"$TMPDIR/gate-check.txt"
if ! grep -q '^No open gates found\.$' "$TMPDIR/gate-check.txt"; then
	sed -n '/^{/,$p' "$TMPDIR/gate-check.txt" | jq -e '.schema_version >= 1 and .dry_run == true' >/dev/null
fi
bd mol --help >/dev/null
bd swarm --help >/dev/null
bd comments --help >/dev/null
bd show --help >/dev/null
