---
name: cycles-of-tdd
description: >-
  Guides code changes with Test-Driven Development as nested cycles: the three
  laws, red/green/refactor, specific-to-generic generalization via the
  Transformation Priority Premise, and periodic architecture boundary checks.
  Use when implementing features or bug fixes with TDD, when code feels too
  example-driven or "stuck", or when a test-first loop needs design check-ins
  beyond basic red/green/refactor.
---

# Cycles of TDD

## Quick start

For each behavior:

1. Write one small failing test.
2. Write the smallest amount of code to pass it.
3. Refactor while tests stay green.
4. Every few tests, ask whether the code is becoming more general through the smallest useful transformation.
5. Every hour or so, step back and review boundaries and architecture.

## Workflows

### 1. Nano-cycle: The Three Laws

- Write no production code before a failing test.
- Write no more test code than needed to fail, or to fail to compile.
- Write no more production code than needed to make the current failing test pass.
- Prefer line-by-line or nearly line-by-line movement.

### 2. Micro-cycle: Red / Green / Refactor

- `RED`: add a failing unit test for one behavior.
- `GREEN`: make it pass with the simplest code that could work.
- `REFACTOR`: clean names, duplication, and structure without changing behavior.
- Treat refactoring as continuous work, not a later cleanup phase.
- Avoid horizontal slicing: do one test, one implementation step, then repeat.

### Verify RED / GREEN

Before moving on:
- `RED`: the new test fails for the expected reason, not because of setup or typos.
- `GREEN`: the new test passes, related tests stay green, and output is clean.
- During `RED` and `GREEN`, run the smallest test scope that covers the change.
- Tests should verify observable behavior through public interfaces, not implementation details.
- Name tests with concrete examples of behavior instead of abstract capability labels.
- Prefer real code; mock only when unavoidable.
- If the test is hard to write, simplify the interface before adding more code.

### 3. Milli-cycle: Specific / Generic / TPP

Every few tests, stop and inspect the direction of the design:

- Are the tests becoming more specific examples of behavior?
- Is the production code becoming more general in response?
- Would the latest code likely pass plausible unwritten tests too?
- When generalizing, can the next step be a smaller transformation instead of a design leap?

Use the Transformation Priority Premise to prefer the smallest move that increases generality, such as moving from a constant to a calculation, from a scalar to a collection, or from an unconditional path to a conditional one.

If the code only satisfies the exact examples already written, it is probably too specific.

### 4. Primary cycle: Boundaries

Roughly once per hour, zoom out:

- Identify boundaries you are approaching or crossing.
- Decide which side of each boundary the current behavior belongs on.
- Use those architecture decisions to guide the next round of tests and implementation.

### 5. Recovery: When You Get Stuck

If the next step requires a large leap outside the tiny TDD loop:

1. Treat that as a signal of local optimization.
2. Backtrack to an earlier passing test.
3. Remove or rewrite overly specific tests.
4. Rebuild with tests that add specificity more slowly and code that adds generality sooner.
5. Use TPP to choose a smaller transformation instead of forcing a large redesign in one jump.

## Heuristics

- Getting the code to work is only half the job; the other half is keeping it easy to change.
- If production code starts mirroring test data too closely, generalize it.
- If generalization feels blocked, pick a smaller TPP move.
- If refactoring is being postponed, part of TDD is being skipped.
- If a test needs many mocks or awkward setup, treat that as a boundary or design smell.
- If architecture concerns are surfacing, pause and review boundaries instead of pushing through blindly.

## Advanced features

See [REFERENCE.md](REFERENCE.md) for prompts, review questions, and a compact operating checklist.
