# Workflow Evidence Lifecycle

`codex-mesh` represents workflow completion with contract-shaped records.
Terminal liveness and unstructured agent prose are not closeout records. A
workflow step is closeable only when the Beads task id, CUE-shaped result
envelope, and goal predicate evidence refer to the same unit of work.

This note covers the current public lifecycle around Beads formulas,
`mesh workflow`, goal predicates, role payloads, and close decisions. It
documents existing behavior and contracts; it does not define new behavior.

## Lifecycle Summary

1. Select a Beads formula.
2. Create or select Beads-owned work from that formula.
3. Compute readiness from Beads state and formula dependencies.
4. Emit step state and runner decisions through `mesh workflow`.
5. Dispatch a ready step to an agent transport, or emit wait, block, or close.
6. Record the result as a role-typed `#ResultEnvelope`.
7. Evaluate goal predicate evidence when the close path requires it.
8. Close only with a green predicate and a matching result envelope.
9. Follow-up formulas such as `loop-until-dry` and `completeness-critic` can
   be used to drive convergence and closeout review.

Beads owns durable task state. `codex-mesh` plans, dispatches, evaluates local
predicates, and emits CUE-shaped records. It does not persist a second workflow
database.

## Formula Selection

Repo-local formulas live under `.beads/formulas`. The shipped workflow formulas
are:

- `cue-first-feature`
- `review-wave`
- `judge-panel`
- `loop-until-dry`
- `completeness-critic`

Each formula is validated as `#Formula` in `model/contract.cue`. A formula has a
name, type, version, and a non-empty list of steps. Each step has an id, title,
goal description, goal check string, and expected result payload.

The public workflow request names the formula:

```json
{
  "record_type": "workflow_request",
  "formula": "review-wave"
}
```

`mesh workflow plan|run|status` reads the matching
`.beads/formulas/<formula>.formula.json` file unless a formula directory is
passed explicitly.

## Beads Task Ownership

Beads is the durable layer for task DAGs, readiness, status, assignment, gates,
comments, and closeout records. Formula pouring and child task creation are
Beads-owned operations.

`mesh workflow` does not create a scheduler record or private lifecycle
database. The current runner maps formula steps to deterministic child task ids
beneath the request parent task, such as:

```text
<parent_task>.1
<parent_task>.2
<parent_task>.3
```

Those ids are used in emitted `#WorkflowStepState`, `#RunnerDecision`, and
`#ResultEnvelope` joins. The durable meaning of those tasks remains Beads state.

## Step Readiness

A formula step can depend on earlier formula steps through `depends_on`.

The current workflow runner marks a step as:

- `ready` when all declared dependencies are closed;
- `blocked` when dependencies are not closed;
- `closed` when the request includes a completed result envelope for that
  step's task id;
- `failed` when the request includes a failed or blocked result envelope for
  that step's task id.

This status is emitted as `#WorkflowStepState`. It is planning state, not
durable task truth.

## Placement

For every selected step, `mesh workflow` emits a placement record. Placement
names:

- repo id;
- Beads task id;
- role;
- cwd;
- placement key;
- execution mode;
- isolation mode;
- communication channel;
- command-set mutation flags;
- Beads mutation requirements.

Read-only steps can use a shared checkout. Mutating steps require worktree or
main-owned isolation. Merge work requires main-owned isolation and Beads
merge-slot coordination.

## Runner Decisions

Each step state maps to a `#RunnerDecision`:

- `dispatch`: the step is ready and has a transport target.
- `wait`: dependencies are not closed yet.
- `block`: the result envelope reports failed or blocked work.
- `close`: the step has a green predicate status and a completed result
  envelope.
- `plan`: allowed by the contract for non-dispatch planning decisions.

Runner decisions are emitted for operator review. The workflow contract rejects
hidden dispatch and provider-specific public fields.

## Dispatch

`mesh wave dispatch` consumes:

```sh
bd ready --parent <epic> --exclude-type epic --json
```

It launches at most the requested cap and emits `#WaveStatus` containing
dispatch records. Mutating waves require worktree isolation. Dry-run and status
modes can plan records without launching agents.

Live mutating workflow dispatch has additional contract gates. A live request
must be explicit, authorized, bounded, worktree-isolated, and tied to the
existing spawn adapter. It must not introduce daemon state, scheduler state,
persisted liveness, or provider-specific secrets.

## Role-Typed Result Envelopes

Every closeable unit of work needs a `#ResultEnvelope`. The envelope includes:

- Beads task id;
- session id;
- codex address;
- role;
- status;
- completion timestamp;
- at least one evidence item;
- a role-specific payload.

The role controls the payload shape:

| Role | Payload |
| --- | --- |
| `implementation` | `#ImplementationResult` |
| `reviewer` | `#ReviewFindings` |
| `judge` | `#Verdict` |
| `probe` | `#Verdict` |

Prose-only results fail closed because `#ResultEnvelope` explicitly forbids a
`prose_only` field and requires a typed payload. A summary can exist inside the
typed payload, but it cannot replace the envelope.

## Goal Predicate Evidence

A `#GoalPredicate` freezes the close condition for a Beads task. It requires:

- `frozen: true`;
- `red_check_required: true`;
- `close_requires_green: true`;
- a side-effect-free command check;
- at least one adversarial red state.

`mesh goal check` evaluates a predicate JSON file and emits `#GoalEvaluation`.
The evaluation records the task, phase, status, exit code, predicate, and
predicate evidence.

The goal loop uses three records:

- `#GoalLoopStart`: red-check evidence before work starts.
- `#GoalLoopClose`: close evidence with a green close evaluation and completed
  result envelope.
- `#GoalLoopEscape`: blocked or failed evidence when the loop cannot close.

## Close Decision

A close decision is valid only when the evidence points at the same task.

At the workflow step level, a closed step has:

- `status: "closed"`;
- `predicate_status: "green"`;
- a `#ResultEnvelope` whose task matches the placement task id;
- result status `completed`;
- close policy `green-predicate-and-result-envelope`.

At the goal-loop level, `#GoalLoopClose` additionally requires a close-phase
`#GoalEvaluation` with status `green` and a completed result envelope whose
evidence includes predicate evidence.

Terminal output, an agent summary, and a live kitty window are insufficient
closeout evidence by themselves.

## Example: `review-wave`

The `review-wave` formula has three ordered steps:

| Step | Dependency | Expected Payload | Runtime Role |
| --- | --- | --- | --- |
| `find` | none | `implementation` | request role, usually `implementation` |
| `refute-a` | `find` | `review_findings` | `reviewer` |
| `verdict` | `refute-a` | `verdict` | `judge` |

The first step identifies review targets. The second step runs an adversarial
reviewer against those targets. The third step synthesizes the review into a
pass/fail verdict.

If no result envelopes are supplied, `find` is ready and the dependent steps
wait. If the request supplies a completed `#ResultEnvelope` for
`<parent_task>.1`, then `find` can close and `refute-a` becomes ready. If a
failed envelope is supplied for a step, the runner blocks instead of continuing.

For closeout, the envelopes must match the expected payloads:

- `find` closes with an implementation payload;
- `refute-a` closes with review findings;
- `verdict` closes with a verdict.

Each close depends on the green-predicate-and-result-envelope policy. A written
review or verdict is not enough unless it is packaged in the typed result
envelope with evidence.

## Where Validation Fits

Validation happens at multiple layers:

- formulas are CUE-vetted as `#Formula`;
- workflow requests are CUE-vetted as `#WorkflowRequest`;
- workflow runs are CUE-vetted as `#WorkflowRun`;
- result envelopes are CUE-vetted as `#ResultEnvelope`;
- goal predicates and evaluations are CUE-vetted as `#GoalPredicate` and
  `#GoalEvaluation`;
- valid fixtures must pass and adversarial fixtures must fail closed in
  `./scripts/verify.sh`.

The verifier is strict because the workflow model depends on contract-shaped
evidence rather than inference from prose or live terminal state.

## Follow-Up Closeout

The repository's orchestration default names follow-up formulas for convergence
and closeout:

- `loop-until-dry` for iteration until the predicate stops producing more work;
- `completeness-critic` for final closeout review.

Those formulas do not make `codex-mesh` a daemon or scheduler. They are invoked
workflow templates over Beads-owned tasks and CUE-shaped evidence.
