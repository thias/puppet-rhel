# Class: rhel::virtual
#
# To be included on all nodes, will take care of some basics on virtual
# RHEL servers.
#
class rhel::virtual {

# Only be relevant on virtual nodes
if $::is_virtual == 'true' { # lint:ignore:quoted_booleans

  # We want virsh shutdown from the host to work
  package { 'acpid': ensure => installed }
  service { 'acpid':
    ensure    => 'running',
    enable    => true,
    hasstatus => true,
    require   => Package['acpid'],
  }

} # if is_virtual

}

