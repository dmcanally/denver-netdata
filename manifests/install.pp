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
        #command => '/bin/bash -c \'bash <(curl -Ss https://my-netdata.io/kickstart-static64.sh) --dont-wait --dont-start-it\'',#lint:ignore:140chars
        command => 'curl -s https://api.github.com/repos/netdata/netdata/releases/latest | grep -oP \'"tag_name": "\K(.*)(?=")\'| { read ver;curl -Ls https://github.com/netdata/netdata/releases/download/$ver/netdata-$ver.gz.run -o /tmp/netdata-$ver.gz.run; /bin/sh /tmp/netdata-$ver.gz.run --accept --nox11;}',
        unless  => "ls ${install_dir}",
      }
    }
    default: { fail('invalid install_method specified - should be \'curl\' or \'pkg\'') }
  }
}
