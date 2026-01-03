# Molecule Configuration Structure

This repository uses a split configuration approach for Molecule tests to reduce duplication and make maintenance easier.

## Common Configuration

Most Molecule configuration is defined globally in [`.config/molecule/config.yml`](../../.config/molecule/config.yml) at the project root. This includes:

- **Docker driver configuration** - Default container images, volumes, networking, and privileges
- **Headscale container** - For local testing without Tailscale cloud
- **Ansible provisioner settings** - Collection paths, roles paths, and output formatting
- **Test sequence** - Default steps for all scenarios (dependency → destroy → syntax → create → prepare → converge → idempotence → verify → cleanup → destroy)
- **Galaxy dependencies** - Role and collection requirements

## Scenario-Specific Overrides

Individual test scenarios in `extensions/molecule/role-machine-*/` contain minimal `molecule.yml` files that override or extend the common configuration:

- **scenario.name** - Each scenario must define its unique name
- **provisioner.playbooks** - Scenarios can reuse playbooks from other scenarios (e.g., many reuse `role-machine-default/prepare.yml`)
- **scenario.test_sequence** - Scenarios can skip steps like `idempotence` or `cleanup` if not applicable
- **platforms** - Scenarios can override container images via `MOLECULE_DISTRO` environment variable

## Contributing Guidelines

When making changes to Molecule configuration:

1. **Default changes** → Modify [`.config/molecule/config.yml`](../../.config/molecule/config.yml)
2. **Scenario-specific changes** → Modify the individual scenario's `molecule.yml`
3. **New scenarios** → Start with a minimal `molecule.yml` (just the scenario name) and only add overrides as needed
4. **Platform changes** → Use the `MOLECULE_DISTRO` environment variable rather than hardcoding in scenario files
