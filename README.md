# puppet-rhel

## Overview

Configure Red Hat Enterprise Linux specific files and services.

* `rhel::` : Class to ...

## Examples

See http://forge.puppetlabs.com/puppetlabs/firewall

The firewall classes will provide you with the same configuration as an
original RHEL installation, with ICMP and lo traffic allowed, stateful
connections allowed, and all the rest rejected (not dropped). Note that ssh
is not open by default by this module.

You need this in your site.pp :

    resources { 'firewall': purge => true }
    Firewall {
      before  => Class['::rhel::firewall::post'],
      require => Class['::rhel::firewall::pre'],
    }

Then also this (it includes the main `firewall` modue and both `pre` and `post`
firewall classes from this module :

    class { '::rhel::firewall': }

Though you can also use hiera :

    ---
    classes:
      - '::rhel::firewall'

Note that even though these rules are initially RHEL specific, because they
replicate the original RHEL set of rules, they should work just fine on any
other GNU/Linux distribution.

