# Class: rhel::firewall::pre
#
class rhel::firewall::pre (
  $icmp_limit,
) {

  # Break dependency cycle
  Firewall { require => undef }

  firewall { '001 state related established accept':
    chain  => 'INPUT',
    proto  => 'all',
    state  => [ 'RELATED', 'ESTABLISHED' ],
    action => 'accept',
  }

  if $icmp_limit {
    firewall { '002 icmp drop timestamp-request':
      chain  => 'INPUT',
      proto  => 'icmp',
      icmp   => 'timestamp-request',
      action => 'drop',
    }
    firewall { '003 icmp limit rate':
      chain  => 'INPUT',
      proto  => 'icmp',
      limit  => '50/s',
      action => 'accept',
    }
    firewall { '004 icmp drop':
      chain  => 'INPUT',
      proto  => 'icmp',
      action => 'drop',
    }
  } else {
    firewall { '003 icmp accept':
      chain  => 'INPUT',
      proto  => 'icmp',
      action => 'accept',
    }
  }

  firewall { '005 lo accept':
    chain   => 'INPUT',
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }

}

