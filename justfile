# `just --list --unsorted`
default:
    @just --list --unsorted

# Run local tests
test:
    act pull_request -j forbid-merge-commits

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

