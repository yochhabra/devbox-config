---
description: User level Claude for general guidelines and practices
---

## general
- When asked for questions, at the end of answer, also mention your confidence level between 0-100%.
- When renaming a class, rename the file name as well, also rename all the instance of that class if they no longer seem appropriate.
- when the scope m
- do not default to "user must be right", seek confirmation from user when some fact mentioned by user is not correct
- Also think through edge case scenario, where data flow is not as per the expectatation, only if the scenario is possible.
- Do not forget to handle null values properly wherever needed.
- Do not write workarounds, when updating existing code, read and understand whole file, write a proper long term maintainable fix.
When cleaning code, remove stale references

## Coding style preferences
- One class should have one responsibility, the name of the class should reflect that responsibility
- Write short methods, add submethods to make methods shorter, name of methods should tell what it does. Prefer descriptive method names that convey the semantic difference over a single method with boolean flags or mode parameters.
- Methods should not make assumptions about callers intent.
- Avoid duplication but prefer readability over de-duplication i.e., we want to avoid duplication as much as possible, but we don't want to trade off on readability to get de-duplication.
- Use structured string formatting (e.g., MessageFormat) for strings with variable substitution. Avoid string concatenation for templated output.
- When renaming a method, update all callers and test assertions that depend on the old name or semantics in the same change. Do not leave stale references.
- When needed to map enums, map Unknown or unexpected values must map to a safe default (e.g., UNSPECIFIED), never silently promoted to a meaningful value. If the enum valyes are supposed to be same, or are some atleast in the beginning, then add unit tests to ensure they don't diverge unexpectedly
- Extract conversion/mapping logic into dedicated named methods. Do not inline type conversions at call sites. Each mapping function should have a clear name describing the transformation (e.g., toEventRole, toStatusEnum).

## Code organization
- Separate unrelated concerns into separate branches. Bug fixes, new features, and test utilities should not be bundled. Each branch should have a single clear purpose reviewable in isolation.


## Comments
- Only write comments that explain a non-obvious business decision or constraint — the "why", not the "what" or "how". If removing the comment would not confuse a future reader, do not write it.                                                                         
- Never remove existing comments in the codebase, update it if its becoming stale

## Code Planning guidance
- Avoid duplicate code. Try to abstract out common code to one place.

## Git operations
- I am using Stipe's internal concept and tooling called "stacked PRs". Always use a stacked branch for simplicity of decisions. Stacked branches are supposed to be maintained using "pay stack" commands rather than "git" commands. Use stacked branch skill to check more on how to do git operations on stacked branches and PRs.
- Never fallback to git push if pay stack push fails
- I often work with multiple PRs stacked over one another. Keep context of what's happening in each branch and ensure the update changes are committed in the right branch. When you encounter a new branch, check its stack to find out the base branch, and then check the diff to understand the changes in the branch.
- stacked PRs tooling will handle the rebasing of stacked branches, when a base branch gets updated or even when it gets squash merged, so you don't have to do any rebasing yourself.
- do not ammend commits, ammending breaks stack and downstream branches will need manual rebasing.
- When rebase is needed, ask the user for confirmation, mention explicitly how many commits will be rebased. When rebasing, always take a bakup of branch and compare changes when rebase is done.
- If confidence is lower than 90% during rebase, abort the operation and ask user to do rebase manually.
- When pushing stacked PRs, ensure each branch compiles independently. CI runs on each branch in isolation. 
- do not commit unless explicitly asked by the user. Unless asked for commit, wait for me to review changes before you commit.

## Fixing Cibot failures
- When user gives you a link to a cibot failure to analyze and fix it, also retrospect on how build failure happend and suggest a claude.md update to avoid this failure in future.

## Time consuming tasks
- If any command takes more than 5 minutes, add a log of that in the result. Also add why that might have taken this long and could be avoided in future.

## General pre-push checklist
- Check if you have added some duplicate code. Try to abstract out common code to one place.

## Pre-push checklist for working in zoolander branch
  1. **Always run `dev/build-helper`** after adding/removing/renaming any Java file before committing. This prevents CI failures.
  2. **Run `pay zoo:lint --fix`** on all changed paths before pushing.
  3. After `pay zoo:lint --fix`, also run `dev/fix-java-lints <bazel targets>` to apply google-java-format. `pay zoo:lint` alone does not run google-java-format, which is checked separately by monolint in CI.
