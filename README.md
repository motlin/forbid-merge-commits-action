# forbid-merge-commits-action
A GitHub Composite Action to forbid merge commits inside pull requests.

## When to Ignore or Remove This Action
This action is designed to enforce a workflow that avoids merge commits within pull requests. However, there may be exceptional cases where merge commits are necessary or acceptable. For instance, if a merge commit is used to resolve complex conflicts that cannot be addressed through a rebase, it might be permissible to ignore this action's failure. Always consult with your project's lead or repository administrator before deciding to ignore or bypass this action.

For more guidance on handling merge commits and this action's failure messages, see the section below.

## Handling Failure Messages
If this action fails due to the presence of merge commits, it will print out the offending commits and fail the workflow. This is an indication that the pull request contains merge commits that are not allowed. To resolve this, you can either rebase your branch onto the base branch or consult the section above on when it's safe to ignore or remove this action.

To rebase your branch onto the main branch, use the following command:
```
git pull upstream main --rebase
```
This command rebases the current branch onto the main branch. It's important to ensure that your local branch is up to date with the main branch before pushing changes.

After rebasing, you may need to force push your changes. To do this safely, use the command:
```
git push origin HEAD --force-with-lease
```
This command ensures that you do not overwrite any work on the remote repository that you do not have locally.

Note: The remote name (`origin`) and the upstream branch name (`main`) may vary depending on your repository's configuration. Be sure to replace these with the actual names used in your repository.

## GitHub Workflow
A GitHub workflow has been added to run the composite action against the repository itself. This workflow is defined in `.github/workflows/run-action.yml` and its purpose is to ensure that the repository adheres to its own rules against merge commits.

## How to Add This Action to Your Repository
To add this action to your repository, you need to create a new workflow file in the `.github/workflows/` directory of your repository. Here is a simple example of how to set up the workflow:

```yaml
name: Enforce No Merge Commits
on: pull_request
jobs:
  forbid-merge-commits:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Run Forbid Merge Commits Action
        uses: motlin/forbid-merge-commits-action@main
```

Triggering this action exclusively on `pull_request` events ensures that your repository's pull requests are checked for merge commits before they can be merged. This helps maintain a clean and linear history, which is beneficial for navigating the project's history and understanding the changes made over time.
