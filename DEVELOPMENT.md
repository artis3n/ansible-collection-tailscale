This GitHub repository uses a dedicated "test" Tailscale account to authenticate Tailscale during CI runs. Each Docker container creates a new authorized machine in that test account. The machines are authorized with [ephemeral auth keys][] and are automatically cleaned up.

This authkey is stored in a [GitHub Action secret][] with the name `TAILSCALE_CI_KEY`. To test OAuth authkey compatibility, a Tailscale OAuth client secret is stored as `TAILSCALE_OAUTH_CLIENT_SECRET`. If you are a Collaborator on this repository, you can open a GitHub CodeSpace and these secrets will be pre-populated for you in the environment.

To test this role locally, store the Tailscale ephemeral auth key in a `TAILSCALE_CI_KEY` env var and, if running the `oauth` Molecule scenario, add an OAuth client secret in a `TAILSCALE_OAUTH_CLIENT_SECRET` env var.

Recommended: install `direnv` and configure a `.envrc` file using `.envrc.example` as an example. `direnv` will automatically prepare your local environment when working inside this project.

Alternatively for [Molecule][] testing, you can use a [Headscale][] container that is spun up as part of the create/prepare steps. To do this, set a `USE_HEADSCALE` env variable.

For example:

```bash
USE_HEADSCALE=true molecule test
```

[ephemeral auth keys]: https://tailscale.com/kb/1111/ephemeral-nodes/
[github action secret]: https://docs.github.com/en/actions/reference/encrypted-secrets
[molecule]: https://ansible.readthedocs.io/projects/molecule/
[headscale]: https://github.com/juanfont/headscale/
