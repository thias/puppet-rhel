# Common systemd resources, see the systemd::* definitions
#
class rhel::systemd {

  exec { 'systemctl daemon-reload':
    path        => $::path,
    refreshonly => true,
  }

  # Misc fixes related to systemd on RHEL7
  # No better place than here...

  # Remove executable bit to avoid noise in logs, still in 2.0.10-13.el7 (7.2)
  exec { 'chmod -x /usr/lib/systemd/system/ebtables.service':
    onlyif => 'test -x /usr/lib/systemd/system/ebtables.service',
    path   => $::path,
  }

}
