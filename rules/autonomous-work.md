# Autonomous Work Mode

When you receive a task via `~/.claude/current-task.md` or via a prompt from BigBrain, you are working autonomously without human supervision.

## Operating Principles

- Work independently on implementation: write code, run tests, fix failures, iterate until done
- Follow all coding standards in CLAUDE.md and rules/ files as usual
- For routine implementation choices (naming, structure, patterns): decide yourself and document in `decisions_made`
- For major decisions (architecture changes, changing APIs, adding dependencies, deviating from task spec): DO NOT proceed silently. Report status "blocked" with the decision needed in `blockers`. BigBrain will review and instruct you.
- When in doubt whether something is major: treat it as major. Better to ask than to make a wrong architectural call.

## Branch Safety Rules (CRITICAL)

- You are assigned ONE branch per task. It is specified in `current-task.md` under Constraints.
- **NEVER** run `git checkout` to switch to another branch.
- **NEVER** run `git checkout -b` to create a new branch.
- **NEVER** run `git push` — always use `pay stack push`.
- **NEVER** run `git merge`, `git rebase`, or `git reset`.
- If you need a new branch, report as "blocked" — BigBrain handles branch creation.
- If you are told to sync your stack (e.g., after a parent branch was updated), run `pay stack restack` only.
- If `pay stack push` fails, report as "blocked" — do NOT fall back to `git push`.
- Verify you are on the correct branch before committing: `git branch --show-current`

## Workflow

1. Verify you are on the correct branch (`git branch --show-current`)
2. Read and understand the task fully before starting
3. Plan your approach (what files to change, what tests to write)
4. Implement the changes
5. Run tests and lint — fix any failures
6. Commit and push using `pay stack push`
7. Output your result as structured JSON (see status-reporting.md)

## When to Escalate (report as "blocked")

- Ambiguous requirements where different interpretations lead to different architectures
- Need to change a public API or interface contract
- Adding a new dependency or library
- Task spec seems wrong or contradicts existing code
- Missing permissions or access
- Tests fail in a way that suggests the task spec itself might be incorrect
- Any change that could affect other teams' code

Your output will be reviewed by BigBrain (the orchestrator). It will either give you further instructions or escalate to the human engineer. You are NOT the final decision-maker on non-trivial choices.

## What Counts as "Done"

- Implementation matches the task description
- Tests pass (existing + any new ones you wrote)
- Lint passes (`pay zoo:lint --fix` + `dev/fix-java-lints` for Java)
- Code is pushed to the branch
- You can explain what you did and why
