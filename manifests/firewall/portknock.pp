# Define: rhel::firewall::portknock
#
#   portknock { 'SSH':
#     port1  => '1234',
#     port2  => '2345',
#     port3  => '3456(,
#     dports => [ '22' ],
#   }
#
define rhel::firewall::portknock (
  $port1,
  $port2,
  $port3,
  $dports,
  $seconds_knock = 3,
  $seconds_open  = 3,
  $prefix        = $name,
  $prenumber     = '80',
) {

  # Allow disabling seconds_open, meaning "forever" (until iptables restart)
  if ! $seconds_open or $seconds_open == false or $seconds_open == '' {
    $seconds_open_final = undef
  } else {
    $seconds_open_final = $seconds_open
  }

  # We need separate chains
  firewallchain { [
    "KNOCK_${prefix}_STG1:filter:IPv4",
    "KNOCK_${prefix}_STG2:filter:IPv4",
    "KNOCK_${prefix}_DOOR:filter:IPv4"
  ]:
  }

  # Door
  firewall { "${prenumber}0 portknock ${name} knock2 goes to stg2":
    chain    => "KNOCK_${prefix}_DOOR",
    jump     => "KNOCK_${prefix}_STG2",
    recent   => 'rcheck',
    rname    => "${prefix}_knock2",
    rseconds => $seconds_knock,
  }

  firewall { "${prenumber}1 portknock ${name} knock1 goes to stg1":
    chain    => "KNOCK_${prefix}_DOOR",
    jump     => "KNOCK_${prefix}_STG1",
    recent   => 'rcheck',
    rname    => "${prefix}_knock1",
    rseconds => $seconds_knock,
  }

  # Name only different by $port1 so it conflicts if reused (wanted!)
  firewall { "${prenumber}2 portknock on port ${port1} sets knock1":
    chain  => "KNOCK_${prefix}_DOOR",
    dport  => $port1,
    proto  => 'tcp',
    recent => 'set',
    rname  => "${prefix}_knock1",
  }

  # Stage 1
  firewall { "${prenumber}3 portknock ${name} stg1 remove knock1":
    chain  => "KNOCK_${prefix}_STG1",
    recent => 'remove',
    rname  => "${prefix}_knock1",
  }

  firewall { "${prenumber}4 portknock stg1 set knock2 on ${port2}":
    chain  => "KNOCK_${prefix}_STG1",
    dport  => $port2,
    proto  => 'tcp',
    recent => 'set',
    rname  => "${prefix}_knock2",
  }

  # Stage 2
  firewall { "${prenumber}5 portknock ${name} stg2 remove knock1":
    chain  => "KNOCK_${prefix}_STG2",
    recent => 'remove',
    rname  => "${prefix}_knock1",
  }

  firewall { "${prenumber}6 portknock set heaven on ${port3}":
    chain  => "KNOCK_${prefix}_STG2",
    dport  => $port3,
    proto  => 'tcp',
    recent => 'set',
    rname  => "${prefix}_heaven",
  }

  # Let people in heaven
  firewall { "${prenumber}7 portknock ${name} heaven let connections through":
    jump     => 'accept',
    chain    => 'INPUT',
    dport    => $dports,
    proto    => 'tcp',
    recent   => 'rcheck',
    rname    => "${prefix}_heaven",
    rseconds => $seconds_open_final,
  }

  firewall { "${prenumber}8 portknock ${name} connection initiation to door":
    chain     => 'INPUT',
    dport     => [ $port1, $port2, $port3 ],
    jump      => "KNOCK_${prefix}_DOOR",
    proto     => 'tcp',
    tcp_flags => 'FIN,SYN,RST,ACK SYN',
  }

}

