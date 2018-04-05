#class netdata::uninstall
class netdata::uninstall {

  $service_filepath = $::netdata::service_filepath
  $service_filename = $::netdata::service_filename
  $netdata_cleanup = [
    '/etc/netdata',
    '/opt/netdata',
    '/usr/sbin/netdata',
    '/usr/share/netdata',
    '/usr/libexec/netdata',
    '/var/lib/netdata',
    '/var/cache/netdata',
    '/var/log/netdata',
    '/etc/cron.daily/netdata-updater.sh',
    "${service_filepath}/${service_filename}",
  ]

  service { 'netdata':
    ensure => 'stopped',
    enable => false,
  }

  file { $netdata_cleanup:
    ensure  => 'absent',
    force   => true,
    require => Service['netdata'],
  }

  user { 'netdata':
    ensure  => 'absent',
    require => File[$netdata_cleanup],
  }

  group { 'netdata':
    ensure  => 'absent',
    require => User['netdata'],
  }

}
