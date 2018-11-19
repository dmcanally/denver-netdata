#class netdata::params
class netdata::params {

  case $::osfamily {
    'RedHat': {
      if $::operatingsystemmajrelease < '7' {
        $service_filepath = '/etc/init.d'
        $service_filename = 'netdata'
        $service_filesrc  = 'netdata-init-d'
        $service_filemode = '0755'
      } else {
        $service_filepath = '/etc/systemd/system'
        $service_filename = 'netdata.service'
        $service_filesrc  = 'netdata.service'
        $service_filemode = '0644'
      }
    }
    'Debian': {
      case $::operatingsystem {
        'Ubuntu': {
          if $::operatingsystemmajrelease <= '14.10' {
            $service_filepath = '/etc/init.d'
            $service_filename = 'netdata'
            $service_filesrc  = 'netdata-lsb'
            $service_filemode = '0755'
          } else {
            $service_filepath = '/etc/systemd/system'
            $service_filename = 'netdata.service'
            $service_filesrc  = 'netdata.service'
            $service_filemode = '0644'
          }
        }
        default: {fail("${::hostname}: This module does not support ${::osfamily} - ${::operatingsystem} ${::operatingsystemrelease}")}
      }
    }
    default: {
      fail("${::hostname}: This module does not support ${::osfamily} - ${::operatingsystem} ${::operatingsystemrelease}")
    }
  }
}
