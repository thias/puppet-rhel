# Definition to create firewall rules extracting parameters from the title.
# Useful when dealing with arrays of source IP addresses and networks.
#
define rhel::firewall::proto_dport_source (
  $prefix = '100',
  $action = 'accept',
  $chain  = 'INPUT',
  $ensure = present,
) {

  $proto  = regsubst($title,'^([^_]+)_([^_]*)_([^_]+)$','\1')
  $dport  = regsubst($title,'^([^_]+)_([^_]*)_([^_]+)$','\2')
  $source = regsubst($title,'^([^_]+)_([^_]*)_([^_]+)$','\3')

  # Empty values means 'any' - must pass undef to firewall for this to work
  if $dport != '' { $final_dport = split($dport,',') }

  if $source =~ /:/ {
    $provider = 'ip6tables'
  } else {
    $provider = 'iptables'
  }

  firewall { "${prefix} ${proto}/${dport} from ${source}":
    ensure   => $ensure,
    action   => $action,
    chain    => $chain,
    dport    => $final_dport,
    proto    => $proto,
    source   => $source,
    provider => $provider,
  }

}

