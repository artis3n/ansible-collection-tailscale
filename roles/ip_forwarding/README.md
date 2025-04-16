# artis3n.tailscale.ip_forwarding  <!-- omit in toc -->

This role enables IPv4 and IPv6 forwarding.

## Variables

```yaml
artis3n_tailscale_ip_forwarding_ipv4_state: present
```

Whether to enable IPv4 forwarding.

```yaml
artis3n_tailscale_ip_forwarding_ipv4_value: 1
```

Value for enabling IPv4 forwarding.

```yaml
artis3n_tailscale_ip_forwarding_ipv4_sysctl_file: /etc/sysctl.conf
```

IPv4 sysctl.conf file location.

```yaml
artis3n_tailscale_ip_forwarding_ipv6_state: present
```

Whether to enable IPv6 forwarding.

```yaml
artis3n_tailscale_ip_forwarding_ipv6_value: 1
```

Value for enabling IPv6 forwarding.

```yaml
artis3n_tailscale_ip_forwarding_ipv6_sysctl_file: /etc/sysctl.conf
```

IPv6 sysctl.conf file location.

## Example Playbook

```yaml
- name: Enable IP forwarding
  hosts: all
  roles:
    - role: artis3n.tailscale.ip_forwarding
      vars:
        artis3n_tailscale_ip_forwarding_ipv4_sysctl_file: /etc/sysctl.d/99-tailscale.conf
        artis3n_tailscale_ip_forwarding_ipv6_sysctl_file: /etc/sysctl.d/99-tailscale.conf
```

## Dependencies

### Collections

- [`ansible.posix`](https://docs.ansible.com/ansible/latest/collections/ansible/posix/index.html)

[tailscale ip forwarding docs]: https://tailscale.com/kb/1019/subnets?tab=linux#enable-ip-forwarding
