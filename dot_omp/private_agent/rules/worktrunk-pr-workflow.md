---
description: "Personal agnostic Worktrunk lifecycle + GitHub PR workflow"
alwaysApply: true
---

# Personal agnostic Worktrunk lifecycle + PR workflow

Apply this rule when the user asks to create, work in, finish, publish, PR, merge, clean up, or remove Worktrunk/git worktrees.

This workflow is project-agnostic. Do not hardcode a repository, framework, base branch, PR target branch, PR template, test command, merge strategy, or branch deletion policy.

## Branch concepts

There are two different branch roles. Do not conflate them:

- **Worktree base branch**: branch used to create new worktrees.
- **PR target branch**: branch the pull request is opened against and merged into.

The PR target branch is not always the same as the worktree base branch.

## Default interaction model

- For creating worktrees, the only required business input should be the worktree base branch.
- For PR/merge, the only required business input should be the PR target branch.
- Reuse branch values from the current conversation when the user clearly provided them for that role.
- If the user says only one branch for a full create-and-PR workflow, treat it as both base and PR target unless they later override the PR target.
- If an operation needs a branch role that has not been provided, ask only for that missing branch role.
- Infer branch names from the user's task descriptions using clear conventional names.
- If the user names a source branch/worktree, use it.
- If the current working directory is inside a worktree, infer that worktree as the source for finish/PR/merge operations.
- Ask only when ambiguity would risk touching the wrong branch, deleting work, or targeting the wrong base/PR branch.

## Non-negotiables

- Never assume a missing PR target branch.
- Never assume a missing worktree base branch for worktree creation.
- Never delete a local branch unless the user explicitly asks.
- Treat "deja la rama" / "keep the branch" as preserving the **local branch only**.
- Do not interpret "deja la rama" as any instruction about the remote branch. Never delete or recreate a remote branch unless the user explicitly mentions remote branch deletion/recreation.
- Removing a worktree means removing only the worktree directory/metadata, not the local branch, unless explicitly told otherwise.
- Preserve user work. Do not reset, rebase, merge, force-push, or discard divergent local commits unless it is necessary for the requested workflow and the risk is explained or already covered by the user's instruction.
- Prefer safe commands that fail rather than silently rewriting history, e.g. fast-forward pulls and `--force-with-lease` instead of blind force push.
- Do not invent Jira/ticket IDs, issue numbers, evidence, test results, branch names, or PR fields.

## Creating worktrees

When the user asks to create one or more worktrees:

1. Determine the worktree base branch from the user-provided branch for worktree creation.
2. Update the worktree base branch first using a safe strategy:
   - prefer `git pull --ff-only origin <base-branch>` from the base branch worktree when available
   - otherwise fetch and verify the remote base exists
   - if the local base branch diverged, stop and report; do not merge/rebase/reset automatically
3. Create each requested worktree with Worktrunk from the base branch:
   - `wt switch --create --base <base-branch> --no-cd <new-branch>`
4. Use concise branch names derived from the task:
   - bug fixes: `fix/<short-description>`
   - features: `feat/<short-description>`
   - chores/tasks: `chore/<short-description>` or `task/<short-description>` when that matches repo convention
5. Do not launch editors/agents automatically unless the user asks.
6. Verify creation with `wt list`.
7. If local ignored files are required for new worktrees, rely on the safe opt-in local-file flow below.

## Local-only helper files

- Some projects need local ignored files to make worktrees usable. Treat these as project-specific.
- Keep ignored/local files ignored unless the user explicitly changes policy.
- If using Worktrunk copy-ignored globally, keep it opt-in with `wt step copy-ignored --require-include`.
- Never configure global `wt step copy-ignored` without `--require-include`.
- If a helper allowlist such as `.worktreeinclude` is personal only, keep it out of commits with `.git/info/exclude`.
- Do not commit local helper files unless the user explicitly asks.

## Finishing a worktree

When the user says a worktree/branch is done and asks to PR, merge, or clean it up:

1. Identify the source branch/worktree and PR target branch. Use the PR target branch already given by the user for this workflow unless the user overrides it.
2. If no PR target branch has been provided and a PR/merge is requested, ask for the PR target branch.
3. Inspect source worktree status before changing anything.
4. If there are staged or unstaged changes and the user asked to finish/publish the work, commit them with a concise conventional message unless the user said not to commit.
5. Run targeted verification appropriate to the project and changed files. Choose the narrowest meaningful command from repo conventions, package scripts, existing docs, or changed file type. Do not run broad/project-wide commands unless necessary.
6. Update the PR target branch before PR work using a safe pull/fetch strategy. Prefer `git pull --ff-only origin <pr-target-branch>` when operating on the PR target branch.
7. If the PR target branch cannot fast-forward because it diverged, stop and report the divergence. Do not merge/rebase/reset the PR target branch automatically.
8. Push the feature/source branch.
9. Create the PR with `gh pr create`, targeting the PR target branch for this workflow.
10. Use the repository's PR template when present. Prefer an explicit `--body-file` matching that template over relying on GitHub web UI auto-fill.
11. Before merging, verify the PR contains only intended commits/changes relative to the PR target branch.
12. If the source branch was created from a base branch different from the PR target branch, inspect the PR commit list/diff carefully. Do not assume the diff is correct just because the source branch was valid against its creation base.
13. If the source branch accidentally includes unrelated local-base commits, clean the source branch by rebasing/cherry-picking onto `origin/<pr-target-branch>` and push with `--force-with-lease`; do not do this if it would discard user work or if the unrelated commits may be intentional.
14. Merge with `gh pr merge` only when the user asks to merge. Merge into the PR target branch. Use the repository/user's requested merge strategy. If none is provided, use normal merge (`--merge`) unless repository policy indicates otherwise.
15. Use `--match-head-commit` when possible to avoid merging a changed head.
16. Do not pass `--delete-branch` unless the user explicitly asks to delete a branch through `gh`; if branch deletion is ambiguous, ask whether they mean local, remote, or both.
17. If the user says to keep/leave the branch, preserve the local branch only. Do not treat that as a remote-branch requirement.
18. If asked to remove the worktree while keeping the local branch, use `wt remove --no-delete-branch --foreground <branch>`.
19. Verify final state requested by the user: PR state, local branch existence when requested, worktree removal, target/base status, and any command output claimed. Verify remote branch existence only if the user explicitly asks about remote.

## OMP session preservation

- OMP resume lists are scoped by current folder/cwd.
- If work is moved between worktrees and the user wants to preserve an OMP session, do not delete the original session files.
- Prefer telling the user they can press Tab in the resume picker to view all sessions.
- If the user wants the session to appear under the new worktree's "current folder" resume list, clone the session file/assets from the old cwd bucket to the new cwd bucket and rewrite only the copied session metadata `cwd` to the new worktree path.
- Never mutate the original session when cloning to a different worktree.

## PR body workflow

- Discover the repository's PR template before creating the PR:
  - `.github/pull_request_template.md`
  - `.github/PULL_REQUEST_TEMPLATE.md`
  - `.github/pull_request_template/*.md`
  - `.github/PULL_REQUEST_TEMPLATE/*.md`
- Preserve the repo's headings, checkbox format, ticket placeholders, evidence sections, and testing sections.
- Fill only what is supported by observed changes and verification.
- If a required field needs information the user did not provide, keep the repo placeholder or ask when that field blocks PR creation.
- If evidence is required but no visual change exists, state that explicitly and include the verification command that was run.
