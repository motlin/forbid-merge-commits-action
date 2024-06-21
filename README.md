# forbid-merge-commits-action
A GitHub Composite Action to forbid merge commits inside pull requests.

## When to Ignore or Remove This Action
This action is designed to enforce a workflow that avoids merge commits within pull requests. However, there are scenarios where merge commits are necessary or acceptable. One such scenario is when maintaining a library with stable branches. In the context of maintaining libraries with stable branches, it's acceptable to merge fixes from one branch to another. This is particularly relevant when some branches are designated for writing fixes, while others are targeted for merging these fixes. In such cases, enforcing no merges into branches designated for writing fixes can be a sensible approach.

For instance, if a merge commit is used to resolve complex conflicts that cannot be addressed through a rebase, it might be permissible to ignore this action's failure. Always consult with your project's lead or repository administrator before deciding to ignore or bypass this action.

For more guidance on handling merge commits and this action's failure messages, see the section below.

## Handling Failure Messages
If this action fails due to the presence of merge commits, it will print out the offending commits and fail the workflow. This is an indication that the pull request contains merge commits that are not allowed. To resolve this, you can either rebase your branch onto the base branch or consult the section above on when it's safe to ignore or remove this action. For further assistance, refer to [this explanation](#when-to-ignore-or-remove-this-action).

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
