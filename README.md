# forbid-merge-commits-action
A GitHub Composite Action to forbid merge commits inside pull requests.

## When to Ignore or Remove This Action
This action is designed to enforce a workflow that avoids merge commits within pull requests. However, there may be exceptional cases where merge commits are necessary or acceptable. For instance, if a merge commit is used to resolve complex conflicts that cannot be addressed through a rebase, it might be permissible to ignore this action's failure. Always consult with your project's lead or repository administrator before deciding to ignore or bypass this action.

For more guidance on handling merge commits and this action's failure messages, see the section below.

## Handling Failure Messages
If this action fails due to the presence of merge commits, it will print out the offending commits and fail the workflow. This is an indication that the pull request contains merge commits that are not allowed. To resolve this, you can either rebase your branch onto the base branch or consult the section above on when it's safe to ignore or remove this action. For further assistance, refer to [this explanation](#when-to-ignore-or-remove-this-action).
