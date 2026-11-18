# AGENTS.md

`artis3n.tailscale` is an Ansible collection published to Galaxy. Its one role, `artis3n.tailscale.machine` (`roles/machine/`), installs Tailscale on Linux hosts and joins them to a tailnet with `tailscale up`.

## Writing Ansible

Follow ansible-creator's [Ansible coding guidelines](https://raw.githubusercontent.com/ansible/ansible-creator/refs/heads/main/docs/agents.md) when writing or reviewing role tasks, templates or Molecule playbooks. Where they differ from this repo's existing style, the repo wins:

- **Variable names**: role variables use the `tailscale_` prefix, internal ones included (the guidelines suggest `machine_` and `__`). A few user-facing variables, such as `state`, `verbose` and `release_stability`, have no prefix.
- **Fact access**: dot notation (`ansible_facts.distribution`), not brackets.

The variables in `roles/machine/defaults/main.yml` are the role's public interface: users set them in their playbooks, so renaming one or changing what its default does breaks those playbooks.

## Role invariants

- **Re-authentication**: `tailscale up` reruns only when the node is offline or the state file changes. That file (`$XDG_STATE_HOME/artis3n-tailscale/state`, rendered from `tasks/templates/state.j2`) holds a SHA-256 of the final `tailscale up` arguments, plus the auth key when `auth_key_in_state` is true. Changing how `tailscale_args_string` is assembled in `tasks/install.yml` changes that hash, so every existing node re-authenticates on its first run after users upgrade. Say so in the PR when a change does this.
- **Auth key secrecy**: every task whose arguments or output contain the auth key sets `no_log: "{{ not (insecurely_log_authkey | bool) }}"`, and error output is shown only after `replace(tailscale_authkey, 'REDACTED')`. New tasks that touch the key follow the same pattern.
- **Distro routing**: `tasks/determine_distro_family.yml` maps `ansible_facts.distribution` to a family folder holding `tasks/<family>/install.yml` and `uninstall.yml`. The family lists live in `vars/main.yml`.

## Change checklists

A change is done when every item on its list is done.

- **New user-facing variable**: a default with a comment in `defaults/main.yml`; a `### <name>` section under `## Variables` in `roles/machine/README.md`; a validation task in `tasks/main.yml` when only some values are legal.
- **New distribution**: an entry in a family list in `vars/main.yml`, or a new family branch and folder; a test image in the matrix in `.github/workflows/pull_request_target.yml`; an entry in the supported-OS lists in both `README.md` and `roles/machine/README.md`.
- **New Molecule scenario**: `extensions/molecule/role-machine-<name>/molecule.yml` holding `scenario.name` plus only the overrides it needs (most reuse `role-machine-default`'s `prepare.yml`, `verify.yml` and `cleanup.yml`); a `test-<name>` target in `roles/machine/Makefile`; a job in `pull_request_target.yml`.

## Verifying

- **Lint**: run `make install` once, then `make lint`. It is the same pre-commit run as CI's lint job, including `ansible-lint --profile=production`, and every change must pass it.
- **Molecule**: scenarios live in `extensions/molecule/`, with shared config in `.config/molecule/config.yml`. Run them from `extensions/` with `uv run molecule test --scenario-name role-machine-<name>`. A fresh clone lacks three things Molecule needs:
  - **Path**: the checkout must sit at `…/collections/ansible_collections/artis3n/tailscale`, because Molecule finds the collection by walking four directories up from `extensions/`. In a plain clone, `artis3n.tailscale.machine` fails to resolve.
  - **Docker** that can run privileged systemd containers.
  - **A tailnet**: either `TAILSCALE_CI_KEY`, an ephemeral auth key (the `role-machine-oauth` scenario reads `TAILSCALE_OAUTH_CLIENT_SECRET` instead), or `USE_HEADSCALE=true`, which joins a local Headscale container and needs no key. The Headscale image comes from ghcr.io (`HEADSCALE_IMAGE` overrides it). Headscale's CLI changes between releases, so when this path breaks, look at the Headscale steps in `role-machine-default/prepare.yml` first.
- **When Molecule can't run**: say so in your report and leave the end-to-end check to CI. Test containers get the network they would have in CI or on a real host, so results reflect production: keep any session proxy, and its CA certificate, out of them. When a test container can't reach a package mirror or Tailscale from this machine, Molecule can't run here. On `pull_request_target`, once a maintainer approves the `E2E` environment, CI runs the default scenario on every distro image, most other scenarios on one image each, and three scenarios against Headscale.

## Agent skills

### Issue tracker

Issues and specs live in this repo's GitHub Issues (`artis3n/ansible-collection-tailscale`), managed with the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

The default triage vocabulary, except that `needs-info` maps to the existing `bug:needs-reproduction` label. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `GLOSSARY.md` and `docs/adr/` at the repo root, both created when first needed. See `docs/agents/domain.md`.
