# Define: rhel::firewall::privatesrc
#
# Trivial wrapper to IPv4/IPv6 dual stack simple firewall rules
# for traffic from private IP address space.
#
define rhel::firewall::privatesrc (
  # If we disable IPv6 globally, create only IPv4 fules
  $ipv6    = true,
  $rules = {},
) {

  # The 3 IPv4 networks defined in RFC1918
  create_resources('firewall',
    { "${title} 1" => $rules },
    { source => '10.0.0.0/8'}
  )
  create_resources('firewall',
    { "${title} 2" => $rules },
    { source => '172.16.0.0/12'}
  )
  create_resources('firewall',
    { "${title} 3" => $rules },
    { source => '192.168.0.0/16'}
  )

  if $ipv6 {
    # The IPv6 network defined in RFC4193
    $ipv6_hash = { "${title} ipv6" => $rules }
    $ipv6_parameter = {
      source   => 'fc00::/7',
      provider => 'ip6tables',
    }
    create_resources('firewall',$ipv6_hash,$ipv6_parameter)
  }

}

