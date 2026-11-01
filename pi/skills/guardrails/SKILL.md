---
name: guardrails
description: Set up **check** entrypoint with **ratchets** for automated quality gates
---

# Guardrails

Set up a **check** entrypoint that runs deterministic quality checks locally and
in CI. The `check` goes **green** when healthy, **red** on regression, with
**ratchets** that only tighten over time.

Three leading words anchor the skill:

- **check** - single entrypoint (`make check`, `npm run check`, `mise run
  check`, `just check`) running all guardrails; CI and humans use identical
  invocation
- **ratchet** - committed baseline permitting only improvements; CI fails on
  regression, updates baseline on MRs that fix violations
- **green/red** - observable state; a guardrail earns its place only if it can
  go red on a real regression

## Quality categories

Apply these categories where the detected stack supports them:

| Category | Purpose |
|----------|--------|
| Syntax | Parse/compile failures |
| Security | Vulnerabilities, secrets, unsafe patterns |
| Formatting | Consistent style |
| Linting | Bugs, anti-patterns, complexity |
| Testing | Coverage, mutation, acceptance |
| Dead code | Unused imports, functions, dependencies |
| Warnings | Build/test noise treated as errors |

## Ratchet mechanics

A **ratchet** compares current metrics to a committed baseline. Three outcomes:

| Outcome | Condition | Action |
|---------|-----------|--------|
| **Green** | Metrics match baseline | Pass |
| **Red (regression)** | Metrics worsen | Fail with message: location of new violations + how to fix |
| **Red (improvement)** | Metrics improve | Fail with alert: "baseline cinched"; requires commit of updated baseline file. Next run passes. |

**Guardrail invariant:** One guardrail always checks that baseline files are
clean (no uncommitted changes). This prevents false positives when improvements
cinch the ratchet but the baseline isn't yet committed.

## Process

### Step 1: Detect the stack

Read the repo's manifests and existing config to identify the stack and the
tooling already in play: `package.json`, `pyproject.toml`, `Cargo.toml`,
`go.mod`, `*.csproj`/`*.sln`, `build.gradle`/`pom.xml`, plus config files
(`.eslintrc`, `.prettierrc`, `[tool.ruff]`, …).

Done when you can name the stack and list the tools already configured.

If no manifest is found, ask the user for the stack before continuing.

### Step 2: Choose a tool per category

For each category, pick the de facto standard for the detected stack, preferring
tooling the repo already has. Confirm each candidate runs non-interactively and
exits non-zero on failure.

Done when every applicable category maps to one tool with a known CLI command.

### Step 3: Set the **baseline**

Assess repo state to choose ratchet strategy:

- **Clean repo** (zero violations): hard threshold ("0 lint errors", ">80%
  coverage")
- **Legacy repo** (existing violations): committed baseline file, preferring
  tool-native formats (`.coverage-baseline`, `mutation-snapshot.json`) or custom
  files under `.guardrails/`

Done when each ratcheted category specifies its baseline file and update rule.

### Step 4: Present recommendations

Output an ordered list, simplest to hardest by estimated config lines:

```md
## Recommended Guardrails

1. **[Category]**: [Tool] - ~X lines of config
   - Website: [github url]
   - Command: `[exact CLI command]`
   - Check: add to `[entrypoint]`
   - Baseline: [file]
   - Ratchet: [how it tightens]
```

**Wait for user confirmation before implementing.**

### Step 5: Implement (on approval)

1. Write the tool config files.
2. Add each command to the `check` entrypoint — reuse the repo's task runner
(`make`, `npm`, `mise`, `just`), creating one if absent.
3. Emit a CI workflow (GitHub Actions, GitLab CI, …) that runs `check` — the
same command, no direct tool invocations.
4. Document how to run `check` in the README.

Done when `check` runs green locally and the CI workflow calls it verbatim.
