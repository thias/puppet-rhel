# Class to enable IPv4 network masquerade
#
class rhel::firewall::masquerade (
  $prefix   = '100',
  $outiface = 'eth0',
  $ensure   = present,
) {

  Firewall {
    ensure => $ensure,
    proto  => 'all',
  }

  firewall { "${prefix} forward out through ${outiface}":
    action   => 'accept',
    chain    => 'FORWARD',
    outiface => $outiface,
    table    => 'filter',
  }
  firewall { "${prefix} state related established accept":
    action => 'accept',
    chain  => 'FORWARD',
    state  => [ 'RELATED', 'ESTABLISHED' ],
  }

  firewall { "${prefix} masq 10.0.0.0/8 out through ${outiface}":
    chain    => 'POSTROUTING',
    jump     => 'MASQUERADE',
    outiface => $outiface,
    source   => '10.0.0.0/8',
    table    => 'nat',
  }
  firewall { "${prefix} masq 172.16.0.0/12 out through ${outiface}":
    chain    => 'POSTROUTING',
    jump     => 'MASQUERADE',
    outiface => $outiface,
    source   => '172.16.0.0/12',
    table    => 'nat',
  }
  firewall { "${prefix} masq 192.168.0.0/16 out through ${outiface}":
    chain    => 'POSTROUTING',
    jump     => 'MASQUERADE',
    outiface => $outiface,
    source   => '192.168.0.0/16',
    table    => 'nat',
  }

}

