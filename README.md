# devbox-config

Personal Claude Code configuration deployed to all devboxes.

## Structure

```
rules/              # Claude rules files (symlinked to ~/.claude/rules/)
  autonomous-work.md        # How to work without human supervision
  status-reporting.md       # JSON output schema for BigBrain
  stacked-prs.md            # Git workflow with pay stack
  figma-approvals-notifications.md  # Figma project rules
skills/
  bigbrain/SKILL.md         # BigBrain orchestration skill (local machine only)
settings/
  devbox-settings.local.json  # Permissions for autonomous operation
CLAUDE.md           # Global coding standards
setup.sh            # Deployment script (run on devbox)
```

## Usage

### On a new devbox (via pay-server dotfiles)

`pay-server/devbox/dotfiles/yochhabra/setup.sh` clones this repo and runs `setup.sh`.

### Manual deployment

```bash
git clone https://github.com/yochhabra/devbox-config.git ~/.devbox-config
~/.devbox-config/setup.sh
```
