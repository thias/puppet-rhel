# Manage a simple systemd service
#
define rhel::systemd::service (
  $ensure  = 'present',
  $source  = undef,
  $content = undef,
) {

  include '::rhel::systemd'

  file { "/etc/systemd/system/${title}.service":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => $source,
    content => $content,
    notify  => Exec['systemctl daemon-reload'],
  }

}
