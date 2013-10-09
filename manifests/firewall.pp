# Class: rhel::firewall
#
class rhel::firewall (
  $ipv6             = true,
  $icmp_limit       = false,
  $ipv4_src_ssh     = undef,
  $ipv4_src_nrpe    = undef,
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

  if $ipv4_src_ssh {
    firewall { '010 ssh':
      action   => 'accept',
      chain    => 'INPUT',
      proto    => 'tcp',
      source   => $ipv4_src_ssh,
    }
  }
  if $ipv4_src_nrpe {
    firewall { '011 nrpe':
      action   => 'accept',
      chain    => 'INPUT',
      proto    => 'tcp',
      source   => $ipv4_src_nrpe,
    }
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

