define rhel::firewall::proto_dport_source (
  $prefix = '100',
  $action = 'accept',
  $chain  = 'INPUT',
  $ensure = present,
) {

  $proto  = regsubst($title,'^([^_]+)_([^_]+)_([^_]+)$','\1')
  $dport  = regsubst($title,'^([^_]+)_([^_]+)_([^_]+)$','\2')
  $source = regsubst($title,'^([^_]+)_([^_]+)_([^_]+)$','\3')

  if $source =~ /:/ {
    $provider = 'ip6tables'
  } else {
    $provider = 'iptables'
  }

  firewall { "${prefix} ${proto}/${dport} from ${source}":
    ensure   => $ensure,
    action   => $action,
    chain    => $chain,
    dport    => $dport,
    proto    => $proto,
    source   => $source,
    provider => $provider,
  }

}

