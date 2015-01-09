# Define: rhel::firewall::dualstack
#
# Trivial wrapper to IPv4/IPv6 dual stack simple firewall rules.
#
define rhel::firewall::dualstack (
  # If we disable IPv6 globally, create only IPv4 fules
  $ipv6    = true,
  $rules = {},
) {

  $ipv4_hash = { "$title" => $rules }
  create_resources('firewall',$ipv4_hash)

  # FIXME: The ip6tables doesn't have a working purge. Argh.
  if $ipv6 {
    $ipv6_hash = { "${title} ipv6" => $rules }
    $ipv6_parameter = { 'provider' => 'ip6tables' }
    create_resources('firewall',$ipv6_hash,$ipv6_parameter)
  }

}

