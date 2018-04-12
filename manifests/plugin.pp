#class netdata::plugin
class netdata::plugin {

  $ensure               = $::netdata::ensure
  $hostname             = $::netdata::hostname
  $history              = $::netdata::history
  $config_dir           = "${::netdata::install_dir}${::netdata::config_dir}"
  $user                 = $::netdata::user
  $group                = $::netdata::group
  $web_log              = $::netdata::web_log

  File {
    ensure => $ensure,
    backup => '.puppet-bak',
    owner  => $user,
    group  => $group,
    require => Class['::netdata::config'],
    notify => Service['netdata'],
  }

  create_resources('netdata::plugin::web_log', $web_log)

  concat { "${config_dir}/python.d/web_log.conf":
    ensure  => $ensure,
    owner   => $user,
    group   => $group,
    require => Class['::netdata::install'],
    notify  => Service['netdata'],
  }

  concat::fragment { 'web_log.conf+01':
    target  => "${config_dir}/python.d/web_log.conf",
    content => template("${module_name}/plugin/web_log.conf.erb"),
    order   => '01',
  }

  concat { "${config_dir}/python.d/bind_rndc.conf":
    ensure  => $ensure,
    owner   => $user,
    group   => $group,
    require => Class['::netdata::install'],
    notify  => Service['netdata'],
  }

  concat::fragment { 'bind_rndc.conf+01':
    target  => "${config_dir}/python.d/bind_rndc.conf",
    content => template("${module_name}/plugin/bind_rndc.conf.erb"),
    order   => '01',
  }

}
