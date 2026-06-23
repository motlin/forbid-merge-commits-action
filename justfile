# `just --list --unsorted`
default:
    @just --list --unsorted

# Run local tests
test: test-pass test-fail

# Verify the action passes a PR with no merge commits
test-pass:
    #!/usr/bin/env bash
    set -uo pipefail
    output=$(act pull_request -j forbid-merge-commits -e test/event-pull-request-pass.json 2>&1) && status=0 || status=$?
    echo "$output"
    if [ "$status" -ne 0 ]; then
        echo "FAIL: expected the action to pass a no-merge PR, but it exited $status" >&2
        exit 1
    fi
    if ! grep -q 'No merge commits found' <<<"$output"; then
        echo "FAIL: action passed but did not report 'No merge commits found'" >&2
        exit 1
    fi

# Verify the action fails a PR containing a merge commit
test-fail:
    #!/usr/bin/env bash
    set -uo pipefail
    output=$(act pull_request -j forbid-merge-commits -e test/event-pull-request-fail.json 2>&1) && status=0 || status=$?
    echo "$output"
    if [ "$status" -eq 0 ]; then
        echo "FAIL: expected the action to detect a merge commit and fail, but it passed" >&2
        exit 1
    fi
    if ! grep -q 'Found merge commits' <<<"$output"; then
        echo "FAIL: action exited non-zero but did not report 'Found merge commits'" >&2
        exit 1
    fi

# Lint the action.yml file
lint-action:
    yamllint action.yml

# Lint workflow files
lint-workflows:
    yamllint .github/workflows/*.yml

# Lint the workflow files
lint: lint-action lint-workflows

# Run everything
precommit: test lint
