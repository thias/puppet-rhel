# Trivial class to prepare aide and not much more
#
class rhel::aide::common {

  package { 'aide': ensure => 'installed' }

  file { '/etc/aide':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
    purge  => true,
  }

}
