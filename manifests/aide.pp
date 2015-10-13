# Simple aide setup to be run daily and report changes by email.
#
define rhel::aide (
  $lines,
  $cron_ensure   = 'present',
  $cron_mailto   = undef,
  $cron_weekday  = '*',
  $cron_monthday = '*',
  $cron_hour     = '*',
  $cron_minute   = '00',
) {

  include "::${module_name}::aide::common"

  file { "/etc/aide/${title}.conf":
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template("${module_name}/aide/aide.conf.erb"),
  }

  file { '/usr/local/sbin/aide-cron':
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
    source => "puppet:///modules/${module_name}/aide/aide-cron",
  }

  if $cron_mailto {
    $cron_environment = [ "MAILTO=${cron_mailto}" ]
  } else {
    $cron_environment = undef
  }

  cron { "aide-${title}":
    command     => "/usr/local/sbin/aide-cron ${title}",
    user        => 'root',
    environment => $cron_environment,
    weekday     => $cron_weekday,
    monthday    => $cron_monthday,
    hour        => $cron_hour,
    minute      => $cron_minute,
  }

}
