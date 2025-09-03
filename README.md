# "Forbid merge commits" GitHub Action

This action enforces clean semi-linear git history that looks like this:

<img width="141" src="https://github.com/motlin/forbid-merge-commits-action/assets/244258/6b1bbe24-e6bd-43c4-8f1a-3d8e3691435f">

It fails on Pull Requests that include merge commits.

This rule is designed to prevent developers from merging the base branch _into_ their branch as a way of making it up-to-date. This creates [foxtrot commits](https://www.atlassian.com/blog/it-teams/stop-foxtrots-now) and confusing git log graphs.

This rule is also designed to prevent using GitHub's "Update Branch" button, which merges the base branch _into_ the source branch. Instead, use the pull-down "Rebase Branch" button. This rebases the source branch _onto_ the base branch. This is a common problem if "Always suggest updating pull request branches" is enabled, because "Update Branch" is the default choice in the pull-down and [it cannot be disabled or changed](https://github.com/orgs/community/discussions/12032).

## Failure messages

When this action fails, it leaves instructions pointing [here to this README.md](https://github.com/motlin/forbid-merge-commits-action/tree/main?tab=readme-ov-file#handling-failure-messages) on how to handle the failures.

Example failure message [in check logs](https://github.com/motlin/forbid-merge-commits-action/actions/runs/10797911339/job/29950215274):

![image](https://github.com/user-attachments/assets/e98738b0-7c94-4161-a342-9b003909c40c)

Example failure message [in checks summary](https://github.com/motlin/forbid-merge-commits-action/actions/runs/10797911339/attempts/1#summary-29950215274):

<img width="1132" alt="image" src="https://github.com/user-attachments/assets/3d0f825b-2116-4089-a0bc-7ac00ae6e5de">

## Handling failure messages

If this action fails due to the presence of merge commits, it will print out the offending commits and fail the workflow. To resolve this, you will need to rebase your branch onto the base branch.

If the "Rebase Branch" button is available, you can use that.

<img width="335" src="https://github.com/motlin/forbid-merge-commits-action/assets/244258/dbb60788-3908-41f9-81db-4ba568d97fd5">

Otherwise, you can rebase your branch locally using the following commands:

```bash
git pull <upstream-remote> <base-branch> --rebase
git push --force-with-lease origin <branch_name>
```

The `<upstream-remote>` is usually named `upstream` or `origin`. The `<base-branch>` is usually named `main` or `master`.

## When this action may not be applicable

Sometimes including merge commits in Pull Requests is acceptable. For example, when maintaining a library it is common to fix problems on stable branches and merge the fixes into the default branch. In such cases, you may want to configure this action to run only on some branches, or remove it entirely.

## How to add this action to your repository

This action is designed to trigger only `on: pull_request` events. To add this action to your repository, you can add it to an existing workflow file that triggers only on Pull Requests, or create a new workflow file. 

To add this action to your repository, you need to create a new workflow file in the `.github/workflows/` directory.

Here is an example `.github/workflows/pull-request.yml` workflow.

```yaml
on: pull_request

jobs:
  forbid-merge-commits:
    runs-on: ubuntu-latest
    steps:
      - name: Run Forbid Merge Commits Action
        uses: motlin/forbid-merge-commits-action@main
        with:
          # Defaults to 'true', set to 'false' for warning-only mode
          fail-on-merge-commits: 'true'
          # Defaults to 'Refer to [handling failure messages](...) for guidance.'
          fail-notice: 'Your custom failure message here'
```

## Recommended settings

This action is designed to be used with the settings "Allow merge commits" and "Always suggest updating pull request branches."

<img width="808" src="https://github.com/motlin/forbid-merge-commits-action/assets/244258/138ab7c1-6c14-4b1b-8bc4-a61fc3f6cfb6">

This action **does not** enforce that your PR branch is up-to-date with the base branch. To ensure Pull Requests are up-to-date with the base branch before merging, enable GitHub's "Require branches to be up to date before merging" option in your branch protection rules or ruleset.

<img width="797" alt="require-branches-up-to-date" src="https://github.com/user-attachments/assets/5cfc4c72-7f5d-4f9e-b93f-704762b957c6" />

## How is this different from the "Require Linear History" status check?

"Require linear history" does not allow merges at all. It is used with "Squash and Merge" or "Rebase and Merge" and creates a completely linear history.

This workflow is meant to be used with the "Merge" button on Pull Requests. These merge commits let us see who clicked the merge button, and which commits were grouped together into a single Pull Request with multiple commits.

## GitHub Merge Queue Compatibility

GitHub's merge queue does not automatically rebase queued PRs on top of each other before merging. While this action prevents merge commits within individual PRs, the merge queue may still produce a non-linear history when multiple PRs are merged in succession.

## Prior art

This action is similar to [cyberark/enforce-rebase](https://github.com/cyberark/enforce-rebase), which runs using a deprecated version of Node. This action is implemented as a Composite Action using yaml, which is easier to keep up-to-date.