# Implementing a ratchet

## Tool-native baselines first

When the tool ships its own baseline (ESLint bulk suppressions, PHPStan,
detekt, basedpyright), use it. Confirm it tightens: fixed violations must drop
out of the file. If they don't on a normal run, add the tool's
prune/regenerate command to `check` so the trailing `git diff --exit-code`
catches the change.

## Count ratchet

Otherwise, ratchet a single number stored in `.guardrails/<name>.count`:

```sh
#!/usr/bin/env sh
# usage: .guardrails/ratchet.sh <name> <current>   (lower is better)
set -eu
name=$1 current=$2
file=".guardrails/$name.count"
baseline=$(cat "$file" 2>/dev/null || echo "$current")

if [ "$current" -gt "$baseline" ]; then
  echo "red: $name regressed $baseline -> $current" >&2
  exit 1
fi
echo "$current" > "$file"
[ "$current" -lt "$baseline" ] && echo "$name tightened $baseline -> $current: commit $file"
exit 0
```

Wire it into `check` with a count from the tool's machine-readable output, and
on regression rerun the tool in human format so the developer sees locations:

```sh
count=$(npx eslint . -f json | jq '[.[].errorCount] | add')
.guardrails/ratchet.sh eslint "$count" || { npx eslint .; exit 1; }
```

## Gotchas

- The tool exits non-zero while violations exist. Ignore its exit code in the
  counting pipeline; the ratchet decides red.
- A missing baseline file is created from the current value, so the first run
  goes red via `git diff` until it is committed.
- Higher-is-better metrics (coverage %, mutation score): flip both
  comparisons.
- `[ -gt ]` is integer-only. Store percentages as integer hundredths, or
  compare with `awk`.
