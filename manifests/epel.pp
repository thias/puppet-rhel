# Class to enable EPEL on Enterprise Linux
#
class rhel::epel (
  $ensure = undef,
  # These *will* break. But will not get fixed. See :
  # https://fedorahosted.org/fedora-infrastructure/ticket/3605
  $release_rpm5 = 'epel-release-5-4.noarch.rpm',
  $release_rpm6 = 'epel-release-6-8.noarch.rpm',
  $release_rpm7 = 'e/epel-release-7-5.noarch.rpm',
) {

  if $facts['os']['family'] != 'RedHat' {
    fail("Class ${title} is not supported on ${facts['os']['family']} OS family")
  }

  case $facts['os']['release']['major'] {
    '5': { $release_rpm = $release_rpm5 }
    '6': { $release_rpm = $release_rpm6 }
    '7': { $release_rpm = $release_rpm7 }
    default: {
      fail("Class ${title} is not supported on OS release ${facts['os']['release']['major']}") # lint:ignore:80chars
    }
  }

  if $ensure == 'absent' {

    package { 'epel-release': ensure => 'absent' }

  } else {

    # We need to short-circuit puppet's package provider for this
    exec { 'yum install epel-release':
      command => "yum -y --nogpgcheck install http://download.fedoraproject.org/pub/epel/${facts['os']['release']['major']}/i386/${release_rpm}", # lint:ignore:80chars
      path    => [ '/bin', '/usr/bin' ],
      unless  => 'rpm -q epel-release',
    }

  }

}

