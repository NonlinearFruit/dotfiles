## Operating Checklist

### Second-by-second

- Is there exactly one failing test driving this code?
- Am I adding only enough test code to fail?
- Am I adding only enough production code to pass?

### Minute-by-minute

- Have I completed a full `red -> green -> refactor` loop?
- Did I actually refactor while green, instead of promising to do it later?
- Am I running the smallest test scope that covers this change?

### Every few tests

- Are the tests more specific than the code?
- Would this implementation pass sensible cases I have not written yet?
- Am I solving the general case, or only the current example?
- What is the next smallest transformation that increases generality?

### TPP moves

Use the Transformation Priority Premise when the next step feels too large. Prefer smaller moves that preserve momentum, such as:

- constant -> calculation
- scalar -> collection
- unconditional path -> conditional path
- special case accumulation -> simpler general rule

### About once an hour

- What boundary am I nearing: UI, persistence, network, policy, domain, or integration?
- Should this behavior live on a different side of that boundary?
- Are my current tests pulling me toward or away from the intended architecture?

## Failure Modes

### Code is too specific

Symptoms:

- Hard-coded branches that match test inputs too literally
- Production code that looks like a transcription of the last test
- Each new test forces a special case instead of simplifying the whole design

Response:

1. Stop adding more special cases.
2. Step back to the last good test.
3. Choose a different next test that encourages a more general solution.
4. Pick the next smaller TPP move instead of another literal special case.

### You are stuck

Symptoms:

- The next passing step needs a large jump in code
- You feel forced to leave the small-step TDD loop
- Refactoring no longer seems possible without breaking everything
- The test needs many mocks or awkward setup just to express one behavior

Response:

1. Backtrack to an earlier test.
2. Delete the narrow path that trapped you.
3. Re-approach with smaller tests and more general production code.
4. Use TPP to select a smaller transformation rather than a jump in design.
5. Reconsider the boundary or interface before adding more test scaffolding.

## Short prompt to apply this skill

"Use the cycles of TDD: obey the three laws at tiny scale, complete red/green/refactor at test scale, generalize every few tests with the smallest useful TPP move, and review architectural boundaries about once an hour. If stuck, backtrack and choose a smaller transformation."
