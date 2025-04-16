# Ansible Collection - artis3n.tailscale  <!-- omit in toc -->

[![Ansible Collection Downloads](https://img.shields.io/ansible/collection/d/artis3n/tailscale)](https://galaxy.ansible.com/ui/repo/published/artis3n/tailscale)
[![GitHub release (latest SemVer including pre-releases)](https://img.shields.io/github/v/release/artis3n/ansible-collection-tailscale?include_prereleases)](https://github.com/artis3n/ansible-collection-tailscale/releases)
[![Molecule Tests](https://github.com/artis3n/ansible-collection-tailscale/actions/workflows/pull_request_target.yml/badge.svg)](https://github.com/artis3n/ansible-collection-tailscale/actions/workflows/pull_request_target.yml)
![GitHub last commit](https://img.shields.io/github/last-commit/artis3n/ansible-collection-tailscale)
![GitHub](https://img.shields.io/github/license/artis3n/ansible-collection-tailscale)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/artis3n)](https://github.com/sponsors/artis3n)
[![GitHub followers](https://img.shields.io/github/followers/artis3n?style=social)](https://github.com/artis3n/)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/artis3n/ansible-collection-tailscale?quickstart=1)

_This repo is the successor to <https://github.com/artis3n/ansible-role-tailscale>._

This collection provides a series of roles, plugins, and modules to manage your Tailscale Tailnet and Tailscale devices on Linux systems.

```bash
ansible-galaxy collection install artis3n.tailscale
```

Supported operating systems for Tailscale devices:
- Debian / Ubuntu
- CentOS / RedHat
- Rocky Linux / AlmaLinux
- Amazon Linux 2023
- Fedora
- Arch Linux
- OpenSUSE
- Oracle Linux
- Raspbian

See the [CI worfklow](https://github.com/artis3n/ansible-collection-tailscale/blob/main/.github/workflows/pull_request_target.yml) for the list of distribution versions actively tested in each pull request.

If you or your organization gets value out of this collection, I would very much appreciate one-time or recurring [sponsorship](https://github.com/sponsors/artis3n?sponsor=artis3n) of this collection.

## Roles

- [`artis3n.tailscale.machine`](/roles/machine/): Ansible role to install and configure Tailscale on a Linux server.

## Plugins

Coming soon
