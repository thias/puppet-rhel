# Restore ACL friendly user umask like it was until RHEL8 included
class rhel::umask (
  Enum['present','absent'] $ensure = 'present',
) {

  # No need to apply on RHEL prior to 9
  if versioncmp($facts['os']['release']['major'], '9') >= 0 {
    file { '/etc/profile.d/umask.sh':
      ensure => $ensure,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => "puppet:///modules/${module_name}/umask.sh",
    }
  }

}
