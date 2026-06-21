#!/bin/bash
set -euxo pipefail

# Deploy Claude config from this repo to ~/.claude/
# Called by pay-server dotfiles setup.sh or manually

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Deploying Claude config from devbox-config..."

# Ensure directories exist
mkdir -p ~/.claude/rules

# Symlink rules
for rule in "$SCRIPT_DIR"/rules/*.md; do
  ln -sf "$rule" ~/.claude/rules/"$(basename "$rule")"
done

# Symlink CLAUDE.md
ln -sf "$SCRIPT_DIR/CLAUDE.md" ~/.claude/CLAUDE.md

# Copy settings (not symlink — Claude may modify it at runtime)
cp "$SCRIPT_DIR/settings/devbox-settings.local.json" ~/.claude/settings.local.json

# Install git hooks
if [ -d /pay/src/.git/hooks ]; then
  echo "Installing git hooks..."
  for hook in "$SCRIPT_DIR"/hooks/*; do
    HOOK_NAME=$(basename "$hook")
    # Don't overwrite existing hooks — chain them
    if [ -f "/pay/src/.git/hooks/$HOOK_NAME" ] && [ ! -L "/pay/src/.git/hooks/$HOOK_NAME" ]; then
      echo "  Skipping $HOOK_NAME (existing hook present)"
    else
      ln -sf "$hook" "/pay/src/.git/hooks/$HOOK_NAME"
      chmod +x "/pay/src/.git/hooks/$HOOK_NAME"
      echo "  Installed $HOOK_NAME"
    fi
  done
fi

echo "Claude config deployed successfully!"
