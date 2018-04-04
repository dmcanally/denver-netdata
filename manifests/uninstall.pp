#class netdata::uninstall
class netdata::uninstall {

  $install_dir = $::netdata::install_dir

  exec {'uninstall':
    path    => ['/bin','/sbin','/usr/bin','/usr/sbin'],
    command => "${install_dir}/netdata-uninstaller.sh",
    onlyif  => "ls ${install_dir}/netdata-uninstaller.sh",
  }

  file { $install_dir:
    ensure  => absent,
    require => Exec['uninstall'],
  }

}
