#class netdata::install
class netdata::install {

  $install_dir          = $::netdata::install_dir
  $install_method       = $::netdata::install_method
  $package_names        = $::netdata::package_names

  case $install_method {
    'pkg': {
      ensure_packages($package_names, {'ensure' => 'present'})
    }
    'curl': {
      exec {'install':
        path    => ['/bin','/sbin','/usr/bin','/usr/sbin'],
        command => '/bin/bash -c \'bash <(curl -Ss https://my-netdata.io/kickstart-static64.sh) --dont-wait --dont-start-it\'',#lint:ignore:140chars
        unless  => "ls ${install_dir}",
      }
    }
    default: { fail('invalid install_method specified - should be \'curl\' or \'pkg\'') }
  }

}
