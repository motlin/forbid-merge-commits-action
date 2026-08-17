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

# Cut a release: tag VERSION, move the floating major tag, push both, and create the GitHub release
[arg("version", long="version", help="Release version")]
release version: precommit
    #!/usr/bin/env bash
    set -euo pipefail
    version='{{ version }}'
    tag="v${version#v}"
    major="${tag%%.*}"
    git fetch --quiet origin
    if [ -n "$(git status --porcelain)" ]; then
        echo "Working tree is not clean; commit or stash first." >&2
        exit 1
    fi
    if [ "$(git rev-parse HEAD)" != "$(git rev-parse origin/main)" ]; then
        echo "HEAD is not at origin/main; push or rebase first." >&2
        exit 1
    fi
    git tag "$tag"
    git tag --force "$major"
    git push origin "$tag"
    git push --force origin "$major"
    gh release create "$tag" --title "$tag" --generate-notes --latest
