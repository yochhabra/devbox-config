# Status Reporting for BigBrain

When working autonomously (task assigned via BigBrain), your final output MUST be valid JSON matching this schema. Output ONLY the JSON — no markdown fences, no preamble.

## Output Schema

```json
{
  "status": "completed | failed | blocked",
  "summary": "1-2 sentence description of what was accomplished",
  "branch": "branch-name-that-was-pushed",
  "files_changed": ["path/to/file1.java", "path/to/file2.java"],
  "tests_run": "command used to run tests",
  "tests_passed": true,
  "lint_passed": true,
  "pushed": true,
  "blockers": [],
  "decisions_made": ["chose X over Y because Z (routine, proceeded)"],
  "needs_decision": [
    {
      "question": "Should we use approach A or B?",
      "context": "A is simpler but less extensible, B adds complexity but supports future X",
      "recommendation": "A",
      "impact": "high | medium | low"
    }
  ],
  "follow_up_needed": ["optional: things BigBrain should know for next task"]
}
```

## Field Details

- **status**: "completed" if task is done and pushed. "failed" if you tried but couldn't finish (tests won't pass, etc). "blocked" if you need external input.
- **summary**: What a reviewer would want to know at a glance.
- **branch**: The exact branch name you pushed to.
- **files_changed**: Relative paths from repo root.
- **tests_passed/lint_passed**: false if they fail even after your attempts to fix.
- **pushed**: false if you couldn't push (e.g., CI gate, permission issue).
- **blockers**: Empty array if none. Otherwise describe what's blocking.
- **decisions_made**: Routine engineering choices you made yourself (naming, structure, simple patterns). Document reasoning so BigBrain can verify.
- **needs_decision**: Major decisions you did NOT make — you're asking BigBrain to decide. Include your recommendation. When this array is non-empty, status should be "blocked".
- **follow_up_needed**: Anything the next task should account for.
