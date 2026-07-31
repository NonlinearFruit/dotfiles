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

## Workflows

### 1. Nano-cycle: The Three Laws

- Write no production code before a failing test.
- Write no more test code than needed to fail, or to fail to compile.
- Write no more production code than needed to make the current failing test pass.
- Prefer line-by-line or nearly line-by-line movement.

Done when: exactly one test is failing, that test fails for the expected reason (not setup or syntax), and the production change makes only that test pass — nothing more was added.

### 2. Micro-cycle: Red / Green / Refactor

- `RED`: add a failing unit test for one behavior.
- `GREEN`: make it pass with the simplest code that could work.
- `REFACTOR`: clean names, duplication, and structure without changing behavior.
- Treat refactoring as continuous work, not a later cleanup phase.
- Avoid horizontal slicing: do one test, one implementation step, then repeat.

### Completion criteria: RED / GREEN / REFACTOR

`RED` is done when: the new test fails for the expected reason — not because of setup, imports, or typos. Run the smallest test scope; if it fails for the wrong reason, fix the test before writing any production code.

`GREEN` is done when: the new test passes, all previously passing tests are still green, and output is clean. If unrelated tests broke, fix them before moving to REFACTOR.

`REFACTOR` is done when: every name communicates intent without requiring the reader to look at the body; no logic is duplicated across the production code or the tests; structure fits the shape of the problem. All tests must remain green throughout. If you cannot refactor without breaking tests, the design needs a smaller step — backtrack rather than skip.

Additional constraints that apply during RED and GREEN:
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

Use the Transformation Priority Premise to prefer the smallest move that increases generality. See [TPP moves](REFERENCE.md) for a ranked list of transformations.

Done when: you can answer yes to "would this implementation plausibly pass reasonable unwritten cases?" If no — the code is too specific. Before writing the next test, either choose a different next test that encourages a more general solution, or apply the next smaller TPP move. Do not proceed until the answer is yes.

### 4. Primary cycle: Boundaries

Roughly once per hour, zoom out:

- Identify boundaries you are approaching or crossing.
- Decide which side of each boundary the current behavior belongs on.
- Use those architecture decisions to guide the next round of tests and implementation.

Done when: every boundary you are nearing has a decided side, and the next test is chosen to honor that decision. If a boundary is too uncertain to decide, that uncertainty is the work — resolve it (sketch, discuss, or spike) before resuming the micro-cycle.

## Heuristics

- If a test needs many mocks or awkward setup, treat that as a boundary or design smell.
- If architecture concerns are surfacing, pause and review boundaries instead of pushing through blindly.

## Reference

See [REFERENCE.md](REFERENCE.md) for the operating checklist, TPP moves, failure modes (including stuck recovery), and a short prompt for this skill.
