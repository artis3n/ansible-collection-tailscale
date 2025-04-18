#!/usr/bin/env make


# If local, make sure TAILSCALE_CI_KEY env var is set.
# This is automatically populated in GitHub Codespaces.
.PHONY: test-all
test-all:
ifndef TAILSCALE_CI_KEY
	$(error TAILSCALE_CI_KEY is not set)
else
	cd ../../extensions && uv run molecule test --all
endif

.PHONY: test-default
test-default:
ifndef TAILSCALE_CI_KEY
	$(error TAILSCALE_CI_KEY is not set)
else
	cd ../../extensions && uv run molecule test --scenario-name role-machine-default
endif

.PHONY: test-idempotent-up
test-idempotent-up:
ifndef TAILSCALE_CI_KEY
	$(error TAILSCALE_CI_KEY is not set)
else
	cd ../../extensions && uv run molecule test --scenario-name role-machine-idempotent-up
endif

.PHONY: test-args
test-args:
ifndef TAILSCALE_CI_KEY
	$(error TAILSCALE_CI_KEY is not set)
else
	cd ../../extensions && uv run molecule test --scenario-name role-machine-args
endif

.PHONY: test-absent
test-absent:
ifndef TAILSCALE_CI_KEY
	$(error TAILSCALE_CI_KEY is not set)
else
	cd ../../extensions && uv run molecule test --scenario-name role-machine-state-absent
endif

.PHONY: test-oauth
test-oauth:
ifndef TAILSCALE_OAUTH_CLIENT_SECRET
	$(error TAILSCALE_OAUTH_CLIENT_SECRET is not set)
else
	cd ../../extensions && uv run molecule test --scenario-name role-machine-oauth
endif

.PHONY: test-strategy-free
test-strategy-free:
ifndef TAILSCALE_CI_KEY
	$(error TAILSCALE_CI_KEY is not set)
else
	cd ../../extensions && uv run molecule test --scenario-name role-machine-strategy-free
endif

.PHONY: test-reinstall
test-reinstall:
ifndef TAILSCALE_CI_KEY
	$(error TAILSCALE_CI_KEY is not set)
else
	cd ../../extensions && uv run molecule test --scenario-name role-machine-reinstall
endif

.PHONY: test-headscale
test-headscale:
	cd ../../extensions && USE_HEADSCALE=true uv run molecule test --scenario-name role-machine-default
