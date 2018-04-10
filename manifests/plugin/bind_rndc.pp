#class netdata::plugin::bind_rndc
define netdata::plugin::bind_rndc (
  String  $zonename     = $name,
  Integer $update       = 1,
  Integer $priority     = 60000,
  Integer $retries      = 60,
  Integer $detect_retry = 0,
) {

  concat::fragment { "bind_rndc.conf+02_${$zonename}":
    target  => "${::netdata::plugin::config_dir}/python.d/bind_rndc.conf",
    content => template("${module_name}/plugin/bind_rndc.erb"),
    order   => '02',
  }
}
