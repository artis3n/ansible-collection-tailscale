#!/usr/bin/env make

# Install uv via your preferred method: https://docs.astral.sh/uv/getting-started/installation/
.PHONY: install
install:
	uv python install --python-preference managed
	uv sync
	uv run pre-commit install --install-hooks
	uv run ansible-galaxy install -r requirements.yml

.PHONY: clean
clean:
	rm -rf ./.ansible-dependencies
	uv cache clean
	rm -rf .venv

.PHONY: update
update:
	uv sync --upgrade
	uv run pre-commit autoupdate

.PHONY: lint
lint:
	uv run ansible-lint --profile=production

.PHONY: test
test: test-default test-absent

# If local, make sure TAILSCALE_CI_KEY env var is set.
# This is automatically populated in GitHub Codespaces.
.PHONY: test-all
test-all:
ifndef TAILSCALE_CI_KEY
	$(error TAILSCALE_CI_KEY is not set)
else
	uv run molecule test --all
endif

.PHONY: test-default
test-default:
ifndef TAILSCALE_CI_KEY
	$(error TAILSCALE_CI_KEY is not set)
else
	cd extensions && uv run molecule test --scenario-name default
endif

.PHONY: test-idempotent-up
test-idempotent-up:
ifndef TAILSCALE_CI_KEY
	$(error TAILSCALE_CI_KEY is not set)
else
	cd extensions && uv run molecule test --scenario-name idempotent-up
endif

.PHONY: test-args
test-args:
ifndef TAILSCALE_CI_KEY
	$(error TAILSCALE_CI_KEY is not set)
else
	cd extensions && uv run molecule test --scenario-name args
endif

.PHONY: test-absent
test-absent:
ifndef TAILSCALE_CI_KEY
	$(error TAILSCALE_CI_KEY is not set)
else
	cd extensions && uv run molecule test --scenario-name state-absent
endif

.PHONY: test-oauth
test-oauth:
ifndef TAILSCALE_OAUTH_CLIENT_SECRET
	$(error TAILSCALE_OAUTH_CLIENT_SECRET is not set)
else
	cd extensions && uv run molecule test --scenario-name oauth
endif

.PHONY: test-strategy-free
test-strategy-free:
ifndef TAILSCALE_CI_KEY
	$(error TAILSCALE_CI_KEY is not set)
else
	cd extensions && uv run molecule test --scenario-name strategy-free
endif

.PHONY: test-headscale
test-headscale:
	cd extensions && USE_HEADSCALE=true uv run molecule test --scenario-name default
