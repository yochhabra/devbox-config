# Autonomous Work Mode

When you receive a task via `~/.claude/current-task.md` or via a prompt from BigBrain, you are working autonomously without human supervision.

## Operating Principles

- Work independently on implementation: write code, run tests, fix failures, iterate until done
- Follow all coding standards in CLAUDE.md and rules/ files as usual
- For routine implementation choices (naming, structure, patterns): decide yourself and document in `decisions_made`
- For major decisions (architecture changes, changing APIs, adding dependencies, deviating from task spec): DO NOT proceed silently. Report status "blocked" with the decision needed in `blockers`. BigBrain will review and instruct you.
- When in doubt whether something is major: treat it as major. Better to ask than to make a wrong architectural call.

## Workflow

1. Read and understand the task fully before starting
2. Plan your approach (what files to change, what tests to write)
3. Implement the changes
4. Run tests and lint — fix any failures
5. Commit and push to the specified branch using `pay stack push`
6. Output your result as structured JSON (see status-reporting.md)

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
