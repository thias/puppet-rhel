# Class: rhel::virtual
#
# To be included on all nodes, will take care of some basics on virtual
# RHEL servers.
#
class rhel::virtual {

# Only be relevant on virtual nodes
if $::is_virtual == 'true' {

  # We want virsh shutdown from the host to work
  package { 'acpid': ensure => installed }
  service { 'acpid':
    enable    => true,
    ensure    => running,
    hasstatus => true,
    require   => Package['acpid'],
  }

} # if is_virtual

}

