#class netdata::stream
define netdata::stream (
  String                            $apikey        = $name,
  Integer                           $history       = 3600,
  Enum['save', 'map', 'ram','none'] $memory_mode   = 'save',
  String                            $health_enable = 'auto',
  String                            $allow_from    = '*',
) {

  concat::fragment { "stream.conf+10_${apikey}":
    target  => "${::netdata::config::config_dir}/stream.conf",
    content => template("${module_name}/streams.erb"),
    order   => "10-${apikey}",
  }
}
