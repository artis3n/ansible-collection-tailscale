#!/usr/bin/env make

# Install uv via your preferred method: https://docs.astral.sh/uv/getting-started/installation/
.PHONY: install
install:
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
	#uv run ansible-lint --profile=production
	uv run pre-commit run -a

.PHONY: test
test: testd
	cd roles/machine && make test-absent

.PHONY: testd
testd:
	cd roles/machine && make test-default
