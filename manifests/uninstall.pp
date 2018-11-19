#class netdata::uninstall
class netdata::uninstall {

  $service_filepath = $::netdata::service_filepath
  $service_filename = $::netdata::service_filename
  $install_method   = $::netdata::install_method
  $package_names    = $::netdata::package_names
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

  case $install_method {
    'curl': {
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
    'pkg': {
      ensure_packages($package_names, { 'ensure' => 'absent' } )
    }
    default: { fail('invalid install_method specified - should be \'curl\' or \'pkg\'') }
  }

}
