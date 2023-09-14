# Class: rhel::virtual
#
# To be included on all nodes, will take care of some basics on virtual
# RHEL servers.
#
class rhel::virtual {

  # Only be relevant on VMs (but not containers)
  if str2bool($::is_virtual) and $::virtual != 'lxc' {

    # We want virsh shutdown from the host to work
    package { 'acpid': ensure => 'installed' }
    ~> service { 'acpid':
      ensure    => 'running',
      enable    => true,
      hasstatus => true,
    }

  }

}
