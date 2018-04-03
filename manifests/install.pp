#class netdata::install
class netdata::install {

  $install_dir          = $::netdata::install_dir

  exec {'install':
    path    => ['/bin','/sbin','/usr/bin','/usr/sbin'],
    command => '/bin/bash -c \'bash <(curl -Ss https://my-netdata.io/kickstart-static64.sh) --dont-wait --dont-start-it\'',#lint:ignore:140chars
    unless  => "ls ${install_dir}",
  }

}
