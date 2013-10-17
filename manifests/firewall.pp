# Class: rhel::firewall
#
class rhel::firewall (
  $ipv6             = true,
  $icmp_limit       = false,
  $src_ssh          = undef,
  $src_nrpe         = undef,
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

  # firewall doesn't support arrays for $source :-(
  # Take the opportunity to support a mix of IPv4/IPv6 in the array
  if $src_ssh {
    # a,b,c -> tcp_22_a,tcp_22_b,tcp_22_c
    $tcp_22_src = regsubst($src_ssh,'^(.+)$','tcp_22_\1')
    proto_dport_source { $tcp_22_src: prefix => '010' }
  }
  if $src_nrpe {
    $tcp_5666_src = regsubst($src_nrpe,'^(.+)$','tcp_5666_\1')
    proto_dport_source { $tcp_5666_src: prefix => '011' }
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

