# Common systemd resources, see the systemd::* definitions
#
class rhel::systemd {

  exec { 'systemctl daemon-reload':
    path        => $::path,
    refreshonly => true,
  }

}
