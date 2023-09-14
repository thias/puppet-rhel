# Define: rhel::net::ipaddress
#
# Add an IP address on a network interface. The definition title is the IP
# address with prefix.
#
# This is similar to rhel::net::ifalias but now using NetworkManager.
#
# Parameters:
#  $iface:
#    Network Interface Name.
#
# Sample Usage:
#  rhel::net::ipaddress { '198.51.100.66/24': iface => 'eth0' }
#
define rhel::net::ipaddress (
  String $iface,
  $ensure = undef,
) {

  if versioncmp($::operatingsystemmajrelease,'9') < 0 {
    fail('This definition relies on NetworkManager system-connections.')
  }

  $ipaddr = $title
  if $ipaddr =~ Stdlib::IP::Address::V4::CIDR {
    $proto = 'ipv4'
  } elsif $ipaddr =~ Stdlib::IP::Address::V6::CIDR {
    $proto = 'ipv6'
  } else {
    fail('Invalid IP address. Must be valid and include prefix.')
  }

  # /!\ We do not use "nmcli conn reload" because this can kick out all vnet*
  # bridge members and leave VMs with no network connectivity.
  # The manual "ip" approach is quite fragile, but there is no better way.

  Exec { path => $::path }

  if $ensure == 'absent' {

    exec { "nmcli conn mod ${iface} -${proto}.addresses ${ipaddr}":
      onlyif => "nmcli conn show ${iface} | grep ${ipaddr}",
    }
    -> exec { "ip addr del ${ipaddr} dev ${iface}":
      onlyif => "ip addr show dev ${iface} | grep ${ipaddr}",
    }

  } else {

    exec { "nmcli conn mod ${iface} +${proto}.addresses ${ipaddr}":
      unless => "nmcli conn show ${iface} | grep ${ipaddr}",
    }
    -> exec { "ip addr add ${ipaddr} dev ${iface}":
      unless => "ip addr show dev ${iface} | grep ${ipaddr}",
    }

  }

}
