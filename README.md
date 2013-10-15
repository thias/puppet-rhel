# puppet-rhel

## Overview

Configure Red Hat Enterprise Linux specific files and services.

* `rhel::firewall` : Class to enable and configure iptables/ip6tables.

## Features

### Firewall

See http://forge.puppetlabs.com/puppetlabs/firewall

**NOTE** : IPv6 ip6tables rules cannot be purged as of October 2013, and there
seems to be very limited interest in fixing this.

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

### Yum Update from Cron

Simple shell script and cron job to automatically run `yum update` at 10:05 on
weekdays (+ a 3-10min wait time to avoid mass parallel downloads) :

```puppet
include yum-cron
```

Many parameters can be changed. Example to have a weekly run on Monday at 6AM
completely silent (no cron output email sent out) :

```puppet
class { 'yum-cron':
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
include rhel::epel
```

To remove it :
```puppet
class { 'rhel::epel': ensure => absent }
```

