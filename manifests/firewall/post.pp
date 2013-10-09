# Class: rhel::firewall::post
#
class rhel::firewall::post (
  $ipv6,
  $ipv4_action,
  $ipv4_reject_with,
  $ipv6_action,
  $ipv6_reject_with,
) {

  # Break dependency cycle
  Firewall { before => undef }

  if $ipv4_action == 'reject' { $ipv4_reject = $ipv4_reject_with }
  firewall { '998 last input':
    action => $ipv4_action,
    chain  => 'INPUT',
    proto  => 'all',
    reject => $ipv4_reject,
  }
  firewall { '999 last forward':
    action => $ipv4_action,
    chain  => 'FORWARD',
    proto  => 'all',
    reject => $ipv4_reject,
  }

  if $ipv6 {
    if $ipv6_action == 'reject' { $ipv6_reject = $ipv6_reject_with }
    firewall { '998 last input ipv6':
      action   => $ipv6_action,
      chain    => 'INPUT',
      proto    => 'all',
      provider => 'ip6tables',
      reject   => $ipv6_reject,
    }
    firewall { '999 last forward ipv6':
      action   => $ipv6_action,
      chain    => 'FORWARD',
      proto    => 'all',
      provider => 'ip6tables',
      reject   => $ipv6_reject,
    }
  }

}

