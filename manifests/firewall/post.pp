# Class: rhel::firewall::post
#
class rhel::firewall::post (
  $ipv6,
  $ipv4_jump,
  $ipv4_reject_with,
  $ipv6_jump,
  $ipv6_reject_with,
) {

  # Break dependency cycle
  Firewall { before => undef }

  if $ipv4_jump == 'reject' { $ipv4_reject = $ipv4_reject_with }
  firewall { '998 last input':
    jump   => $ipv4_jump,
    chain  => 'INPUT',
    proto  => 'all',
    reject => $ipv4_reject,
  }
  firewall { '999 last forward':
    jump   => $ipv4_jump,
    chain  => 'FORWARD',
    proto  => 'all',
    reject => $ipv4_reject,
  }

  if $ipv6 {
    if $ipv6_jump == 'reject' { $ipv6_reject = $ipv6_reject_with }
    firewall { '998 last input ipv6':
      jump     => $ipv6_jump,
      chain    => 'INPUT',
      proto    => 'all',
      protocol => 'ip6tables',
      reject   => $ipv6_reject,
    }
    firewall { '999 last forward ipv6':
      jump     => $ipv6_jump,
      chain    => 'FORWARD',
      proto    => 'all',
      protocol => 'ip6tables',
      reject   => $ipv6_reject,
    }
  }

}

