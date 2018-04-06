#class netdata::plugin::web_log
define netdata::plugin::web_log (
  Optional[Enum['nginx','apache','apache_cache','gunicorn','squid']] $type = undef,
  Stdlib::Absolutepath                                               $logfile,
  String                                                             $url     = $name,
) {

  concat::fragment { "web_log.conf+02_${$url}":
    target  => "${::netdata::plugin::config_dir}/python.d/web_log.conf",
    content => template("${module_name}/plugin/web_log.erb"),
    order   => '02',
  }
}
