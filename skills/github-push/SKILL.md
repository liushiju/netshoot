---
name: github-push
description: Use this skill when local repository changes need to be committed and pushed to an existing GitHub remote. It is for repositories that already have a configured remote and valid credentials, and it provides a safe workflow for checking status, creating a commit, and pushing the current branch.
---

# GitHub Push

Use this skill when the task is to push local repository updates to GitHub.

## Workflow

1. Confirm the repository state with `git status --short`, `git remote -v`, and `git branch --show-current`.
2. Review which files are being pushed so unrelated changes are not included by accident.
3. Run `scripts/push_repo.sh "<repo-path>" "<commit message>"`.
4. If push fails because of authentication, branch protection, or remote rejection, stop and report the exact failure.

## Notes

- This skill assumes the remote already exists.
- The script stages all current changes in the repository with `git add -A`.
- Pass a specific commit message. If none is supplied, the script uses `chore: update repository`.
- If there is nothing to commit, the script skips commit creation and still attempts to push the current branch.

## Script

Use [scripts/push_repo.sh](scripts/push_repo.sh) for the actual operation.
