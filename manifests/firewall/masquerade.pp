class rhel::firewall::masquerade (
  $prefix   = '100',
  $outiface = 'eth0',
  $ensure   = present,
) {

  Firewall {
    ensure   => $ensure,
    table    => 'nat',
    chain    => 'POSTROUTING',
    outiface => $outiface,
    proto    => 'all',
    jump     => 'MASQUERADE',
  }

  firewall { "${prefix} masq 10.0.0.0/8 out through ${outiface}":
    source => '10.0.0.0/8',
  }
  firewall { "${prefix} masq 172.16.0.0/12 out through ${outiface}":
    source => '172.16.0.0/12',
  }
  firewall { "${prefix} masq 192.168.0.0/16 out through ${outiface}":
    source => '192.168.0.0/16',
  }

}

