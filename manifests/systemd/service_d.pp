# Manage a simple systemd service.d override
#
define rhel::systemd::service_d (
  String                   $service,
  Enum['present','absent'] $ensure  = 'present',
  Optional[String]         $source  = undef,
  Optional[String]         $content = undef,
) {

  include '::rhel::systemd'

  if $ensure == 'present' {
    # Work around multiple definition conflict with multiple overrides
    ensure_resource('file', "/etc/systemd/system/${service}.service.d", {
      # Don't absent, there might be other service overrides left
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    })
  }

  file { "/etc/systemd/system/${service}.service.d/${title}.conf":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => $source,
    content => $content,
    notify  => Exec['systemctl daemon-reload'],
  }

}
