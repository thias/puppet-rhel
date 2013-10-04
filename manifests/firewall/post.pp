# Class: rhel::firewall::post
#
class rhel::firewall::post (
  $ipv6,
  $ipv4_action,
  $ipv4_reject_with = undef,
  $ipv6_action,
  $ipv6_reject_with = undef,
) {

notice("ipv4_reject_with: ${ipv4_reject_with}")
notice("ipv6_reject_with: ${ipv6_reject_with}")

  # Break dependency cycle
  Firewall { before => undef }

  firewall { '998 reject':
    action => $ipv4_action,
    chain  => 'INPUT',
    proto  => 'all',
    reject => $ipv4_reject_with,
  }
  firewall { '999 reject':
    action => $ipv4_action,
    chain  => 'FORWARD',
    proto  => 'all',
    reject => $ipv4_reject_with,
  }

  if $ipv6 {
    firewall { '998 reject ipv6':
      action   => $ipv6_action,
      chain    => 'INPUT',
      proto    => 'all',
      provider => 'ip6tables',
      reject   => $ipv6_reject_with,
    }
    firewall { '999 reject ipv6':
      action   => $ipv6_action,
      chain    => 'FORWARD',
      proto    => 'all',
      provider => 'ip6tables',
      reject   => $ipv6_reject_with,
    }
  }

}

