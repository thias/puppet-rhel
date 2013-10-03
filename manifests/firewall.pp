# Class: rhel::firewall
#
class rhel::firewall (
  $icmp_limit = false,
) {

  class { '::firewall': }

  class { '::rhel::firewall::pre':
    icmp_limit => $icmp_limit,
  }

  class { '::rhel::firewall::post': }

}

