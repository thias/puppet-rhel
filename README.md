# puppet-rhel

## Overview

Configure Red Hat Enterprise Linux specific files and services.

* `rhel::firewall` : Class to enable and configure iptables/ip6tables.

## Features

### Facts

* `rhel_kernelrelease`: RHEL kernel release, i.e. '957' for `3.10.0-957.5.1.el7`
* `rhelX_kernelrelease`: RHEL version X kernel release, useful for inventorying.

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

Though you can also use hiera to achieve the same :

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

Port knocking with 3 ports is available to protect any tcp port(s).
Hiera example :

```yaml
rhel::firewall::portknock:
  SSH:
    port1: '1234'
    port2: '2345'
    port3: '3456'
    dports:
      - '22'
```

The original `firewall` module doesn't support passing an array of IP addresses
to the `$source` parameter. To overcome this limitation, the
`rhel::firewall::proto_dport_source` definition can help :

```puppet
$admin_networks = [ '10.64.32.0/24', '192.168.23.4' ]
$proto_dport_admin_networks = prefix($admin_networks, 'tcp_8091_')
rhel::firewall::proto_dport_source { $proto_dport_admin_networks: }
```

The above will open up port 8091/tcp from a network and an address. The syntax
for the `$title` is `<proto>_<dport>_<address>` where `<proto>` can be `all`
and `dport` can be empty to also mean all, or multiple ports separated by
commas.

Masquerade class, one liner to enable masquerading of all 3 RFC1918 networks :

```puppet
class { '::rhel::firewall::masquerade': outiface => 'br0' }

Set `$return_local` to `true` to exclude RFC1918 destinations from masquarading,
required with IPSec LAN to LAN for instance.

```

NOTRACK definition, to disable connection tracking for certain ports :

```
rhel::firewall::notrack { '100 notrack http': iface => 'eth0', port => '80' }
rhel::firewall::notrack { '110 notrack lo': iface => 'lo' }
```

For rules source matching private IP address space, the
`rhel::firewall::privatesrc` definition will automatically create the 3
required IPv4 rules and the required IPv6 rule (if not disabled) :

```
rhel::firewall::privatesrc { '100 rsync':
  rules => {
    action => 'accept',
    proto  => 'tcp',
    dport  => [ '873' ],
  },
}
```

### Virtual

This is a class which can be safely included on all nodes, and will tweak only
virtual nodes based on the `is_virtual` fact.

```puppet
class { '::rhel::virtual': }
```

Features include :
* Making sure `acpid` is installed and running for `virsh shutdown` to work from the
  hypervisor.

### Yum Update from Cron

Simple shell script and cron job to automatically run `yum update` at 10:05 on
weekdays (+ a 3-10min wait time to avoid mass parallel downloads) :

```puppet
include '::rhel::yum_cron'
```

Many parameters can be changed. Example to have a weekly run on Monday at 6AM
completely silent (no cron output email sent out) :

```puppet
class { '::rhel::yum_cron':
  cron_command => '/usr/local/sbin/yum-cron &>/dev/null',
  cron_hour    => '06',
  cron_minute  => '00',
  cron_weekday => '1',
}
```

### Network IP Address Alias

Manage network interfaces IP address aliases :

```puppet
rhel::net::ifalias { 'eth0:0':
  ipaddr => '10.0.0.1', prefix => '32',
}
```

```puppet
rhel::net::ifalias { 'eth0:1':
  ensure => absent,
}
```

### EPEL

Enable or disable the EPEL repository for Red Hat Enterprise Linux :

```puppet
include '::rhel::epel'
```

To remove it :
```puppet
class { '::rhel::epel': ensure => absent }
```

### Systemd

Manage systemd resources (initially services). The common `rhel::systemd` class
is automatically included and will execute `systemctl daemon-reload` when
required. Example :

```puppet
rhel::systemd::service { 'mydaemon':
  source => "puppet:///modules/${module_name}/mydaemon.service",
}
```

### AIDE

Monitor file structure and content changes using AIDE. Use the `rhel::aide`
definition with a descriptive title and an array of valid `aide.conf` lines
for the `$lines` parameter. Example :

```puppet
rhel::aide { 'www':
  cron_mailto => 'webmaster@example.com',
  cron_minute => '*/10',
  lines       => [
    # LSPP same as normal, but excluding one extra hash (smaller db)
    '/var/www/htpasswd        LSPP',
    '/var/www/www.example.com LSPP',
    # These are not relevant
    '!/var/www/www.example.com/shared',
    '!/var/www/www.example.com/tmp',
  ],
}
```

The default cron job is run hourly, but most cron parameters may be overridden.
See the `aide.conf(5)` manual page and the example `/etc/aide.conf` file for
help on the lines syntax.

