# Class: rhel::firewall
#
class rhel::firewall (
  $ipv6             = true,
  $icmp_limit       = false,
  $ipv4_action      = 'reject',
  $ipv4_reject_with = 'icmp-port-unreachable',
  $ipv6_action      = 'reject',
  $ipv6_reject_with = 'icmp6-port-unreachable',
  $portknock        = {},
) {

  class { '::firewall': }

  class { '::rhel::firewall::pre':
    ipv6       => $ipv6,
    icmp_limit => $icmp_limit,
  }

  class { '::rhel::firewall::post':
    ipv6             => $ipv6,
    ipv4_action      => $ipv4_action,
    ipv4_reject_with => $ipv4_reject_with,
    ipv6_action      => $ipv6_action,
    ipv6_reject_with => $ipv6_reject_with,
  }

  # Optional portknock resources to be created
  create_resources(rhel::firewall::portknock,$portknock)

}

