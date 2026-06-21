# Stacked PRs at Stripe

Stripe uses a stacked PRs workflow via `pay stack` commands. Always use these instead of raw git equivalents when working with stacked branches.

## General guidance

### Branch creation
- For branch creation prefer checking out to base branch and then creating stacked branch using `pay stack create <branch-name> --current`
- If you fail to create stacked branch, do not try workarounds, ask user to create the stacked branch for you.

## Key Commands

### Branch Management
- **Create a new stacked branch:** `pay stack create <branch-name>` (interactive) or `pay stack create <branch-name> --current` (stack on current branch, prefer this over interactive)
- **Track an existing branch:** `pay stack track` (converts existing branch to stacked, interactive, will ask you to select base branch)
- **Show current stack:** `pay stack show`
- **List all stacks:** `pay stack list`
- **Checkout a stacked branch:** `pay stack checkout`
- **Rename a stacked branch:** `pay stack rename`
- **Delete a stacked branch:** `pay stack delete <branch-name>`
- **Insert a branch mid-stack:** `pay stack insert <branch-name>`
- **Move a branch to different base:** `pay stack move`
- **Split a branch into multiple:** `pay stack split`

### Pushing & Syncing
- **Push changes:** `pay stack push` (NOT `git push` -- git push breaks child branches)
- **Sync local with remote:** `pay stack sync`
- **Rebase entire stack on master:** `pay stack rebase`
- **Restack (fix internal consistency):** `pay stack restac
k`
- **Prune merged branches:** `pay stack sync --prune`

### PRs
- **Open PR link:** `pay stack pr` (for current branch) or `pay stack show` (for all)
- **Merge order:** Always merge bottom-up (closest to master first)
- After a parent PR merges, auto-restacking will attempt to rebase children automatically
- If auto-restack fails, run `pay stack restack --push` locally

## Critical Rules

1. **NEVER use `git push` on stacked branches** -- always use `pay stack push`
2. **NEVER use `git merge`** -- it creates merge commits that break restacking
3. **NEVER use `git rebase -i`** (interactive rebase) -- it rewrites history and breaks stacked PRs
4. **NEVER use `git reset`** to move branch pointers backward -- it causes commit loss during restack
5. **Prefer append-only commits** -- use `git commit` and `git revert`, not history rewriting
6. **Use `git pull --ff-only`** instead of `git pull` (to avoid merge commits)
7. **Use `git cherry-pick`** instead of `git merge` when pulling in specific commits
8. **NEVER use `git checkout -b` to create new branches** — always use `pay stack create`. `git checkout -b` creates a branch that is NOT registered in the stack hierarchy

## Workflow for New Feature Stack

1. Start from master: `git checkout master && git pull --ff-only`
2. Create first branch: `pay stack create feature-part-1`
3. Make changes, commit with `git commit`
4. Create next branch: `pay stack create feature-part-2 --current`
5. Make changes, commit
6. Push entire stack: `pay stack push`
7. Open PRs via links from `pay stack show`
8. Merge bottom-up, restack as needed

## Troubleshooting

- **Stack inconsistent after git push:** Run `pay stack restack`
- **Need to rebase on latest master:** Run `pay stack rebase`
- **Working across devboxes:** Run `pay stack sync` to pull remote state
- **Branch failed auto-restack:** Run `pay stack restack --push`
- **Unrecognized commits after restack:** Check if merge commits or interactive rebase were used; see troubleshooting docs at go/stack
- **Connection errors:** Try `systemctl --user restart stripe-certproxy{.service,-unix.socket,-tcp.socket}`
- **Get help:** #stacked-prs on Slack