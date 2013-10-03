# Class: rhel::firewall::post
#
class rhel::firewall::post {

  # Break dependency cycle
  Firewall { before => undef }

  firewall { '998 reject':
    chain  => 'INPUT',
    proto  => 'all',
    action => 'reject',
  }

  firewall { '999 reject':
    chain  => 'FORWARD',
    proto  => 'all',
    action => 'reject',
  }

}

