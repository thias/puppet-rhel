# puppet-rhel

## Overview

Configure Red Hat Enterprise Linux specific files and services.

* `rhel::firewall` : Class to enable and configure iptables/ip6tables.

## Features

### Firewall

See http://forge.puppetlabs.com/puppetlabs/firewall

The firewall classes will provide you with the same configuration as an
original RHEL installation, with ICMP and lo traffic allowed, stateful
connections allowed, and all the rest rejected (not dropped). Note that ssh
is not open by default by this module.

You need this in your site.pp :

```puppet
resources { 'firewall': purge => true }
Firewall {
  before  => Class['::rhel::firewall::post'],
  require => Class['::rhel::firewall::pre'],
}
```

Then also this (it includes the main `firewall` modue and both `pre` and `post`
firewall classes from this module :

```puppet
class { '::rhel::firewall': }
```

Though you can also use hiera :

```yaml
---
classes:
  - '::rhel::firewall'
```

Note that even though these rules are initially RHEL specific, because they
replicate the original RHEL set of rules, they should work just fine on any
other GNU/Linux distribution.

The original REJECT icmp messages of 'prohibited' will be replaced with the
more obvious 'unreachable' (to get 'connection refused' on the clients), but
you can get back the RHEL defaults with :

```yaml
rhel::firewall::ipv4_reject_with: 'icmp-host-prohibited'
rhel::firewall::ipv6_reject_with: 'icmp6-adm-prohibited'
```

