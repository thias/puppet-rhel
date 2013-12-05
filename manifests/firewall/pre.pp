# Class: rhel::firewall::pre
#
class rhel::firewall::pre (
  $ipv6,
  $icmp_limit,
) {

  # Break dependency cycle
  Firewall { require => undef }

  rhel::firewall::dualstack { '001 state related established accept':
    rules => {
      action => 'accept',
      chain  => 'INPUT',
      proto  => 'all',
      state  => [ 'RELATED', 'ESTABLISHED' ],
    },
  }

  # Different protocols, icmp vs. ipv6-icmp
  if $icmp_limit != false {
    validate_re($icmp_limit, '^\d+$', '$icmp_limit must be an integer')
    firewall { '002 icmp drop timestamp-request':
      action => 'drop',
      chain  => 'INPUT',
      icmp   => 'timestamp-request',
      proto  => 'icmp',
    }
    firewall { '003 icmp limit rate':
      action => 'accept',
      chain  => 'INPUT',
      limit  => "${icmp_limit}/sec",
      proto  => 'icmp',
    }
    firewall { '004 icmp drop':
      action => 'drop',
      chain  => 'INPUT',
      proto  => 'icmp',
    }
    if $ipv6 {
      firewall { '003 ipv6-icmp limit rate':
        action   => 'accept',
        chain    => 'INPUT',
        limit    => "${icmp_limit}/sec",
        proto    => 'ipv6-icmp',
        provider => 'ip6tables',
      }
      firewall { '004 ipv6-icmp drop':
        action   => 'drop',
        chain    => 'INPUT',
        proto    => 'ipv6-icmp',
        provider => 'ip6tables',
      }
    }
  } else {
    firewall { '003 icmp accept':
      action => 'accept',
      chain  => 'INPUT',
      proto  => 'icmp',
    }
    if $ipv6 {
      firewall { '003 ipv6-icmp accept':
        action   => 'accept',
        chain    => 'INPUT',
        proto    => 'ipv6-icmp',
        provider => 'ip6tables',
      }
    }
  }

  rhel::firewall::dualstack { '005 lo accept':
    rules => {
      action  => 'accept',
      chain   => 'INPUT',
      iniface => 'lo',
      proto   => 'all',
    },
  }

}

