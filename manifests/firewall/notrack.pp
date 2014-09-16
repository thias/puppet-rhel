define rhel::firewall::notrack (
  $ensure = present,
  $iface,
  $port   = undef,
  $proto  = 'tcp',
) {

  Firewall {
    ensure   => $ensure,
    table    => 'raw',
    proto    => $proto,
    jump     => 'NOTRACK',
  }

  firewall { "${title} in":
    chain   => 'PREROUTING',
    dport   => $port,
    iniface => $iface,
  }
  firewall { "${title} out":
    chain    => 'OUTPUT',
    sport    => $port,
    outiface => $iface,
  }

}

