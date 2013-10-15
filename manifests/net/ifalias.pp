# Define: rhel::net::ifalias
#
# Create and start network interface aliases. The definition title is the
# interface name.
#
# Parameters:
#  $ipaddr:
#    Interface IPv4 address. Default: none
#  $netmask:
#    Interface IPv4 network mask. Default: none
#
# Sample Usage:
#  rhel::net::ifalias { 'eth0:0':
#    ipaddr => '10.0.0.1', netmask => '255.255.255.0',
#  }
#
define rhel::net::ifalias (
  $ensure = undef,
  $ipaddr = '',
  $netmask = '',
  $prefix = '',
) {

  if $netmask == '' and $prefix == '' and $ensure != 'absent' {
    fail('Must pass netmask or prefix')
  }
  if $ipaddr == '' and $ensure != 'absent' {
    fail('Must pass ipaddr')
  }

  file { "/etc/sysconfig/network-scripts/ifcfg-${title}":
    ensure  => $ensure,
    content => template("${module_name}/net/ifalias.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  if $ensure == 'absent' {
    $command = "ifconfig ${title} down"
  } else {
    $command = "ifdown ${title}; ifup ${title}"
  }

  exec { $command:
    path        => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
    subscribe   => File["/etc/sysconfig/network-scripts/ifcfg-${title}"],
    refreshonly => true,
  }

}

