#class netdata::service
class netdata::service {

  service {'netdata':
    ensure  => 'running',
    enable  => true,
    require => Class['::netdata::config'],
  }

}
