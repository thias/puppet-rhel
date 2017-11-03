# Class to enable IPv4 network masquerade
#
class rhel::firewall::masquerade (
  $prefix              = '100',
  $outiface            = 'eth0',
  $return_local        = false,
  $return_local_prefix = '050',
  $ensure              = present,
) {

  Firewall {
    ensure => $ensure,
    proto  => 'all',
  }

  # Check if outiface is an Array, otherwise convert it to one
  if !$outiface.is_a(Array) {
    $outiface_final = [ $outiface ]
  } else {
    $outiface_final = $outiface
  }

  $outiface_final.each |$iface| {
    if $return_local {
      firewall { "${return_local_prefix} nomasq to 10.0.0.0/8 out through ${iface}":
        chain       => 'POSTROUTING',
        jump        => 'RETURN',
        outiface    => $iface,
        destination => '10.0.0.0/8',
        table       => 'nat',
      }
      firewall { "${return_local_prefix} nomasq to 172.16.0.0/12 out through ${iface}":
        chain       => 'POSTROUTING',
        jump        => 'RETURN',
        outiface    => $iface,
        destination => '172.16.0.0/12',
        table       => 'nat',
      }
      firewall { "${return_local_prefix} nomasq to 192.168.0.0/16 out through ${iface}":
        chain       => 'POSTROUTING',
        jump        => 'RETURN',
        outiface    => $iface,
        destination => '192.168.0.0/16',
        table       => 'nat',
      }
    }

    firewall { "${prefix} forward out through ${iface}":
      action   => 'accept',
      chain    => 'FORWARD',
      outiface => $iface,
      table    => 'filter',
    }
    firewall { "${prefix} masq 10.0.0.0/8 out through ${iface}":
      chain    => 'POSTROUTING',
      jump     => 'MASQUERADE',
      outiface => $iface,
      source   => '10.0.0.0/8',
      table    => 'nat',
    }
    firewall { "${prefix} masq 172.16.0.0/12 out through ${iface}":
      chain    => 'POSTROUTING',
      jump     => 'MASQUERADE',
      outiface => $iface,
      source   => '172.16.0.0/12',
      table    => 'nat',
    }
    firewall { "${prefix} masq 192.168.0.0/16 out through ${iface}":
      chain    => 'POSTROUTING',
      jump     => 'MASQUERADE',
      outiface => $iface,
      source   => '192.168.0.0/16',
      table    => 'nat',
    }
  }

  # Common rules
  firewall { "${prefix} state related established accept":
    action => 'accept',
    chain  => 'FORWARD',
    state  => [ 'RELATED', 'ESTABLISHED' ],
  }
}

