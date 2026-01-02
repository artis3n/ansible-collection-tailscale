# Ansible Collection: artis3n.tailscale - AI Agent Instructions

## Project Overview

This is an Ansible Collection for installing and managing Tailscale VPN nodes on Linux systems. The collection follows Ansible Collection's canonical directory structure and is published to Ansible Galaxy. The project contains the `artis3n.tailscale.machine` role for Tailscale client management.

## Architecture

### Collection Structure

- **Role**: [`roles/machine/`](../roles/machine/) - Main role for Tailscale installation/configuration
  - Multi-distro support (Debian/Ubuntu, CentOS/RHEL/Rocky/Alma, Fedora, Arch, OpenSUSE)
  - OS-specific installation logic in [`tasks/<distro>/install.yml`](../roles/machine/tasks/)
  - State management via idempotency checks using hashed state files (`~/.local/state/artis3n-tailscale/state`)
- **Test Suite**: [`extensions/molecule/`](../extensions/molecule/) - Molecule test scenarios for different use cases
- **Dependencies**: Requires `community.general` collection (defined in [`galaxy.yml`](../galaxy.yml))

### Key Design Patterns

#### Multi-Distribution Support Pattern
The role uses conditional includes based on `ansible_facts.distribution` to route to OS-specific installation tasks:
- Distribution families defined in [`roles/machine/vars/main.yml`](../roles/machine/vars/main.yml) (e.g., `tailscale_debian_family_distros`)
- Each distro has its own install/uninstall task files in [`roles/machine/tasks/<distro>/`](../roles/machine/tasks/)
- Package repository URLs are templated with `release_stability` variable (stable/unstable)

#### State Idempotency Pattern
The role tracks `tailscale up` command state to avoid unnecessary re-authentication:
- State file stored in [`~/.local/state/artis3n-tailscale/state`](../roles/machine/tasks/files/state_readme.md) (XDG Base Directory spec)
- Contains SHA256 hash of `tailscale_args` + authkey (see [`tasks/templates/state.j2`](../roles/machine/tasks/templates/state.j2))
- `tailscale up` only runs when state changes or Tailscale is offline

#### OAuth vs. Auth Key Handling
The role supports two Tailscale authentication methods:
- **OAuth keys** (`tskey-client-*`): Require `tailscale_tags`, support `tailscale_oauth_ephemeral` and `tailscale_oauth_preauthorized`
  - Authkey string is modified to include OAuth parameters: `<key>?ephemeral=<bool>&preauthorized=<bool>`
- **Auth keys** (`tskey-auth-*`): Traditional node authorization keys
- Detection and validation logic in [`tasks/install.yml`](../roles/machine/tasks/install.yml)

#### Fact Gathering Pattern
After successful `tailscale up`, the role registers facts about the node:
- Queries `tailscale ip --4/--6` and `tailscale whois --json` (see [`tasks/facts.yml`](../roles/machine/tasks/facts.yml))
- Exports: `tailscale_node_ipv4`, `tailscale_node_ipv6`, `tailscale_node_hostname_*`, `tailscale_node_tags`, etc.

## Development Workflow

### Environment Setup
```bash
make install  # Uses uv to sync Python deps, install pre-commit hooks, and install Ansible collections
```
- **Python environment**: Uses `uv` (see [`pyproject.toml`](../pyproject.toml)) with Python 3.13
- **Ansible dependencies**: Installed via `ansible-galaxy install -r requirements.yml` to `.ansible-dependencies/`
- **Pre-commit hooks**: Automatically configured (includes ansible-lint)

### Testing with Molecule

Tests run from [`extensions/`](../extensions/) directory following Molecule's best practices for testing Ansible Collections. The working directory path `collections/ansible_collections/artis3n/tailscale` must be maintained for collection resolution - this is required for Ansible to properly locate the collection and its dependencies.

#### Test Environment Variables
- `TAILSCALE_CI_KEY`: Required ephemeral auth key for most scenarios
- `TAILSCALE_OAUTH_CLIENT_SECRET`: Required for OAuth scenario testing
- `USE_HEADSCALE=true`: Use local Headscale container instead of Tailscale cloud (optional)
- `MOLECULE_DISTRO`: Override test container image (e.g., `geerlingguy/docker-ubuntu2404-ansible:latest`)

#### Running Tests
```bash
# From project root:
make test        # Runs default + state-absent scenarios
make testd       # Runs role-machine-default scenario only

# From roles/machine/:
make test-default      # Default scenario
make test-oauth        # OAuth authentication scenario
make test-headscale    # Using local Headscale
```

#### Molecule Scenario Structure
Each scenario in [`extensions/molecule/`](../extensions/molecule/) contains:
- `molecule.yml`: Defines Docker containers (instance + optional headscale), sets `ANSIBLE_COLLECTIONS_PATH`
- `converge.yml`: Playbook that applies the role
- `verify.yml`: Assertions to validate the scenario
- `cleanup.yml`: De-registration tasks (some scenarios)

The `ANSIBLE_COLLECTIONS_PATH` environment variable is critical - it's set to `"${MOLECULE_PROJECT_DIRECTORY}/../../../..:${MOLECULE_PROJECT_DIRECTORY}/../.ansible-dependencies"` to resolve the collection and its dependencies.

### CI/CD Pipeline

- **PR Testing**: [`.github/workflows/pull_request_target.yml`](../.github/workflows/pull_request_target.yml) runs Molecule tests across ~15 distros using matrix strategy
- **Release**: [`.github/workflows/release.yml`](../.github/workflows/release.yml) publishes to Ansible Galaxy on GitHub release
- **Security**: Tests run with `pull_request_target` and require manual approval of the "PR Tests" environment

## Important Conventions

### Variable Naming
- User-facing variables: lowercase with underscores (e.g., `tailscale_authkey`, `state`)
- Internal/fact variables: prefixed with `tailscale_` (e.g., `tailscale_is_online`, `tailscale_whois`)
- Ansible facts: prefixed with `ansible_facts.` (e.g., `ansible_facts.distribution`)

### Security Considerations
- Auth keys are redacted by default using `no_log: "{{ not (insecurely_log_authkey | bool) }}"`
- Stderr is sanitized with `regex_replace(tailscale_authkey, 'REDACTED')` before display
- State files should be readable only by user (mode `0700` for directory, `0644` for file)

### Error Handling Pattern
When `tailscale up` fails:
1. Capture error with `ignore_errors: true`
2. Display redacted stdout if present (5-second pause for user visibility)
3. Clear state file on error
4. Display redacted stderr and fail explicitly

### Repository Package Management
- **Debian/Ubuntu**: Uses `deb822_repository` module (new format) and cleans up legacy `apt_repository` entries
- **CentOS/RHEL**: Adds Tailscale yum repository by distribution
- **Fedora/Amazon Linux**: Uses dnf repository configuration
- Signing keys are fetched from `https://pkgs.tailscale.com/<stability>/<distro>/`

## Common Patterns to Follow

### When Adding Distribution Support
1. Add to appropriate family list in [`vars/main.yml`](../roles/machine/vars/main.yml)
2. Create `tasks/<distro>/install.yml` and `tasks/<distro>/uninstall.yml`
3. Map distribution codename/version in `vars/main.yml` if needed
4. Update CI matrix in [`.github/workflows/pull_request_target.yml`](../.github/workflows/pull_request_target.yml)

### When Adding Role Variables
1. Add to [`defaults/main.yml`](../roles/machine/defaults/main.yml) if user-facing
2. Add to [`vars/main.yml`](../roles/machine/vars/main.yml) if internal constant
3. Document in [`roles/machine/README.md`](../roles/machine/README.md) with examples
4. Add validation in [`tasks/main.yml`](../roles/machine/tasks/main.yml) if required

### When Adding Molecule Scenarios
1. Create directory in [`extensions/molecule/role-machine-<scenario>/`](../extensions/molecule/)
2. Copy `molecule.yml` template and adjust platforms/environment
3. Add `converge.yml`, `verify.yml`, and optionally `cleanup.yml`, `prepare.yml`
4. Add Make target in [`roles/machine/Makefile`](../roles/machine/Makefile)
5. Add CI job in [`.github/workflows/pull_request_target.yml`](../.github/workflows/pull_request_target.yml) if needed

## References

- **Tailscale CLI docs**: https://tailscale.com/kb/1080/cli/
- **Molecule docs**: https://ansible.readthedocs.io/projects/molecule/
- **Ansible Collections**: https://docs.ansible.com/ansible/latest/dev_guide/developing_collections.html
