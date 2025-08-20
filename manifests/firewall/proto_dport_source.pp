# Definition to create firewall rules extracting parameters from the title.
# Useful when dealing with arrays of source IP addresses and networks.
#
define rhel::firewall::proto_dport_source (
  $ensure = 'present',
  $prefix = '100',
  $jump   = 'accept',
  $chain  = 'INPUT',
) {

  $proto  = regsubst($title,'^([^_]+)_([^_]*)_([^_]+)$','\1')
  $dport  = regsubst($title,'^([^_]+)_([^_]*)_([^_]+)$','\2')
  $source = regsubst($title,'^([^_]+)_([^_]*)_([^_]+)$','\3')

  # Empty values means 'any' - must pass undef to firewall for this to work
  if $dport != '' {
    $final_dport = split($dport,',')
  } else {
    $final_dport = undef
  }

  if $source =~ /:/ {
    $protocol = 'ip6tables'
  } else {
    $protocol = 'iptables'
  }

  firewall { "${prefix} ${proto}/${dport} from ${source}":
    ensure   => $ensure,
    jump     => $jump,
    chain    => $chain,
    dport    => $final_dport,
    proto    => $proto,
    source   => $source,
    protocol => $protocol,
  }

}

