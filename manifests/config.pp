#class netdata::config
class netdata::config {

  $ensure               = $::netdata::ensure
  $hostname             = $::netdata::hostname
  $history              = $::netdata::history
  $install_dir          = $::netdata::install_dir
  $config_dir           = "${::netdata::install_dir}${::netdata::config_dir}"
  $plugins_dir          = "${::netdata::install_dir}${::netdata::plugins_dir}"
  $web_files_dir        = "${::netdata::install_dir}${::netdata::web_files_dir}"
  $cache_dir            = "${::netdata::install_dir}${::netdata::cache_dir}"
  $log_dir              = "${::netdata::install_dir}${::netdata::log_dir}"
  $service_filepath     = $::netdata::service_filepath
  $service_filename     = $::netdata::service_filename
  $service_filesrc      = $::netdata::service_filesrc
  $service_filemode     = $::netdata::service_filemode
  $debug_flags          = $::netdata::debug_flags
  $memory_dedup         = $::netdata::memory_dedup
  $debug_log            = "${log_dir}/${::netdata::debug_logfile}"
  $error_log            = "${log_dir}/${::netdata::error_logfile}"
  $access_log           = "${log_dir}/${::netdata::access_logfile}"
  $memory_mode          = $::netdata::memory_mode
  $web_mode             = $::netdata::web_mode
  $update_every         = $::netdata::update_every
  $web_user             = $::netdata::web_user
  $web_group            = $::netdata::web_group
  $user                 = $::netdata::user
  $group                = $::netdata::group
  $port                 = $::netdata::port
  $bind_to              = $::netdata::bind_to
  $disconnect_webclient = $::netdata::disconnect_webclient
  $remote_master        = $::netdata::remote_master
  $remote_master_port   = $::netdata::remote_master_port
  $remote_master_apikey = $::netdata::remote_master_apikey
  $registry             = $::netdata::registry
  $master               = $::netdata::master
  $remote_registry      = $::netdata::remote_registry
  $remote_registry_port = $::netdata::remote_registry_port
  $registry_group       = $::netdata::registry_group
  $registry_allowfrom   = $::netdata::registry_allowfrom
  $streams              = $::netdata::streams

  File {
    ensure => $ensure,
    backup => '.puppet-bak',
    owner  => $user,
    group  => $group,
    require => Class['::netdata::install'],
    notify => Service['netdata'],
  }

  file { "${config_dir}/netdata.conf":
    content => template("${module_name}/netdata.conf.erb"),
  }

  concat { "${config_dir}/stream.conf":
    ensure  => $ensure,
    owner   => $user,
    group   => $group,
    require => Class['::netdata::install'],
    notify  => Service['netdata'],
  }

  concat::fragment { 'stream.conf+01_includes':
    target  => "${config_dir}/stream.conf",
    content => template("${module_name}/stream.conf.erb"),
    order   => '01',
  }

}
