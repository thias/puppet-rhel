# Class: rhel::yum_cron
#
# Daily yum update run from cron.
#
# Parameters:
#  $ensure:
#    Whether yum-cron should be 'present' or 'absent'. Defaults to 'present'.
#  $script_source:
#    Puppet source to use for the /usr/local/sbin/yum-cron script.
#    Default: "puppet:///modules/${module_name}/yum-cron"
#  $cron_command:
#    The command to be executed from cron. Default: '/usr/local/sbin/yum-cron'
#  $cron_user,
#  $cron_hour,
#  $cron_minute,
#  $cron_weekday,
#  $cron_environment:
#    Cron job parameters. Default is to run as root at 10h05 AM Mon-Fri.
#
# Sample Usage :
#  include '::rhel::yum_cron'
#  class { '::rhel::yum_cron':
#    script_source    => 'puppet:///mymodule/yum-cron-modified',
#    cron_hour        => '06',
#    cron_minute      => '00',
#    cron_weekday     => '1',
#    # Remember that this can potentially affect other jobs...
#    cron_environment => [ 'MAILTO=root@example.com' ],
#  }
#
class rhel::yum_cron (
  $ensure           = undef,
  $script_source    = "puppet:///modules/${module_name}/yum-cron",
  $cron_command     = '/usr/local/sbin/yum-cron',
  $cron_user        = 'root',
  $cron_hour        = '10',
  $cron_minute      = '05',
  $cron_weekday     = '1-5',
  $cron_environment = undef,
) {

  # Plain 'dnf' has changed stdout/stderr and debug levels quite a bit, so
  # use dnf-automatic which is meant for this.
  if $facts['package_provider'] == 'dnf' {
    package { 'dnf-automatic': ensure => 'installed' }
    -> file { '/etc/dnf/automatic.conf':
      source => "puppet:///modules/${module_name}/dnf-automatic.conf",
      mode   => '0644',
      owner  => 'root',
      group  => 'root',
    }
  }

  file { '/usr/local/sbin/yum-cron':
    ensure => $ensure,
    source => $script_source,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  cron { 'yum':
    ensure      => $ensure,
    command     => $cron_command,
    user        => $cron_user,
    hour        => $cron_hour,
    minute      => $cron_minute,
    weekday     => $cron_weekday,
    environment => $cron_environment,
  }

}

