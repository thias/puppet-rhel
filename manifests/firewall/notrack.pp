# Definition to set some network traffic as NOTRACK.
#
define rhel::firewall::notrack (
  $iface,
  $ensure    = present,
  $port      = undef,
  $proto     = 'tcp',
  $outbound  = false,
) {

  Firewall {
    ensure => $ensure,
    table  => 'raw',
    proto  => $proto,
    jump   => 'NOTRACK',
  }
  if $outbound {
    firewall { "${title} in":
      chain   => 'PREROUTING',
      sport   => $port,
      iniface => $iface,
    }
    firewall { "${title} out":
      chain    => 'OUTPUT',
      dport    => $port,
      outiface => $iface,
    }
  } else {
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
}

