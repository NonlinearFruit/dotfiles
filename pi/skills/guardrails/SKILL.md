---
name: guardrails
description: Set up check entrypoint with ratchets for automated quality gates
disable-model-invocation: true
---

# Guardrails

Set up one **check** entrypoint that runs deterministic quality guardrails,
invoked identically by humans and CI.

- **check**: the single entrypoint (`make check`, `npm run check`, `mise run
  check`, `just check`). CI's only quality step is `check`.
- **green/red**: the observable state of `check`. A guardrail earns its place
  only if it goes **red** on a real regression.
- **baseline**: the committed record of a category's current quality: a hard
  threshold, or a baseline file.
- **ratchet**: a baseline that only tightens.

## Quality categories

Apply each category the detected stack supports:

- Syntax: parse/compile failures
- Types: type-checker errors
- Security: vulnerabilities, secrets, unsafe patterns. Pin the vulnerability
  database so new advisories don't turn `check` red without a code change.
- Formatting
- Linting: bugs, anti-patterns
- Complexity: cyclomatic complexity, file/class/function length, parameter
  count; ratchet the offender count, then lower the threshold
- Suppressions: `eslint-disable`, `noqa`, `type: ignore`, `@ts-expect-error`,
  skipped tests (`skip`, `xit`, `[Fact(Skip=...)]`) counts, so no ratchet
  tightens by silencing. Focused tests (`.only`, `fit`): hard zero.
- Testing: coverage, mutation, acceptance
- Dead code: unused imports, functions, dependencies
- Dependencies: undeclared imports, duplicate versions in the lockfile
  (`deptry`, `knip`, `dotnet list package --include-transitive`)
- Duplication: copy-pasted blocks
- Architecture: import cycles, layer-boundary violations
- Drift: lockfiles, codegen, API clients, migrations; regenerate, then
  `git diff --exit-code`
- Infra/config: shell scripts, Dockerfiles, CI workflows (incl. unpinned
  actions/images: `zizmor`, `pinact`), IaC
- Repo hygiene: large files, conflict markers, case-colliding paths, line
  endings (`pre-commit-hooks`)
- Warnings: build/test warnings treated as errors; ratchet deprecation
  warnings (`CS0618`, `@typescript-eslint/no-deprecated`) by count

When the stack has the surface:

- Accessibility: UI a11y rules (`jsx-a11y`, `axe`)
- API compatibility: breaking changes against a committed API report
- API spec lint: OpenAPI/AsyncAPI style and validity (`spectral`, `redocly`)
- Bundle size: shipped asset budgets
- Docs: spelling, markdown lint
- i18n: missing/unused translation keys
- Licenses: disallowed dependency licenses
- Migration safety: locking or destructive DB migrations (`squawk`,
  `strong_migrations`)

## Ratchet mechanics

Each run, a ratchet measures its category and compares it to the committed
baseline file:

| Outcome | Condition | Result |
|---------|-----------|--------|
| **Green** | Matches baseline | Pass |
| **Red (regression)** | Worse than baseline | Fail, naming the new violations' locations and how to fix them. Baseline untouched. |
| **Red (tightened)** | Better than baseline | Ratchet rewrites the baseline file; `check` stays red until it is committed. Next run green. |

`check` ends with `git diff --exit-code` over every baseline file. That one
step makes a tightened baseline red, so improvements land in the same MR as
their baseline.

## Process

### Step 1: Detect the stack

Identify the stack and the tooling already configured from the repo's
manifests and config files. In a monorepo, treat each stack separately.

Done when you can name every stack and list the tools already configured.

If no manifest is found, ask the user for the stack before continuing.

### Step 2: Choose and measure a tool per category

For each category, pick the de facto standard for the stack, preferring tooling
the repo already has. Run each candidate and record its exact command, exit
code, and current value (violation count, coverage %). Keep only tools that run
non-interactively and exit non-zero on failure. If a tool must be installed to
run, mark it unmeasured; Step 6 measures it.

Done when every applicable category maps to one tool with a verified command
and a measured (or marked unmeasured) current value.

### Step 3: Mine repo invariants

Find rules this repo holds that no standard tool checks, from its written
conventions (AGENTS.md, CONTRIBUTING, ADRs), recurring fix commits in
`git log`, and checks already run by hand (CI scripts, PR templates).
Express each as a deterministic check (`ast-grep`, `semgrep`, an
architecture test, a grep count under a ratchet).

Done when you have up to 3 invariants, each citing its evidence (file or
commit) and a command that goes red on a known violation.

### Step 4: Choose the ratchet strategy

Decide per category and invariant, from its measured value:

- **Zero violations**: hard threshold ("0 lint errors", ">=80% coverage").
- **Existing violations**: ratchet with a baseline file, preferring
  tool-native formats (`.coverage-baseline`, `mutation-snapshot.json`) over
  custom files under `.guardrails/`.

Done when each category and invariant names its threshold or baseline file and
the metric it ratchets.

### Step 5: Present recommendations

Output an ordered list, simplest to hardest by estimated config lines:

```md
## Recommended Guardrails

1. **[Category]**: [Tool] - ~X lines of config
   - Website: [github url]
   - Command: `[exact CLI command]`
   - Current: [measured value]
   - Check: add to `[entrypoint]`
   - Baseline: [threshold or file]
   - Ratchet: [metric it tightens]

## Repo Invariants

1. **[Rule]**: [Tool]
   - Evidence: [file or commit]
   - Command: `[exact CLI command]`
   - Current: [measured value]
   - Baseline: [threshold or file]
```

**Wait for user confirmation before implementing.** Implement only the items
the user approves.

### Step 6: Implement approved guardrails

Before writing any ratchet, read [RATCHETS.md](RATCHETS.md).

1. Write the tool config files.
2. Add each command to `check`, reusing the repo's task runner (`make`, `npm`,
   `mise`, `just`). If absent, use the stack's native one.
3. End `check` with `git diff --exit-code` over all baseline files.
4. Emit a CI workflow (GitHub Actions, GitLab CI, ...) whose only quality step
   is `check`.
5. Document in the README how to run `check` and how to commit a tightened
   baseline.

Done when `check` runs green locally, each guardrail has gone red once on an
injected violation (then reverted), and the CI workflow invokes `check`
verbatim.
