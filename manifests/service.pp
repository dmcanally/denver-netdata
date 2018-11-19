#class netdata::service
class netdata::service {

  $ensure               = $::netdata::ensure
  $install_dir          = $::netdata::install_dir
  $install_method       = $::netdata::install_method
  $service_filepath     = $::netdata::service_filepath
  $service_filename     = $::netdata::service_filename
  $service_filesrc      = $::netdata::service_filesrc
  $service_filemode     = $::netdata::service_filemode
  $user                 = $::netdata::user
  $group                = $::netdata::group

  File {
    ensure => $ensure,
    backup => '.puppet-bak',
    owner  => $user,
    group  => $group,
    require => Class['::netdata::config'],
    notify => Service['netdata'],
  }

  unless ($install_method == 'pkg') {
    file { "${service_filepath}/${service_filename}":
      source => "${install_dir}/system/${service_filesrc}",
      mode   => $service_filemode,
    }
  }

  service {'netdata':
    ensure => 'running',
    enable => true,
  }

}
