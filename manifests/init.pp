# Class: netdata
# ===========================
#
# This module deploys and configures netdata. More on netdata here (https://github.com/firehol/netdata).
#
# Parameters
# ----------
#
# * `ensure`
#   Present/Absent
#
# * `hostname`
#   Type:    String
#   Default: $::fqdn
#   Desc:    The hostname of the computer running netdata.
#
# * `history`
#   Type:    Integer
#   Default: 3600
#   Desc:    The number of entries the netdata daemon will by default keep in memory for each chart dimension.
#
# * `install_dir`
#   Type:    String
#   Default: /opt/netdata
#   Desc:    Path in which to deploy netdata locally.
#
# * `install_method`
#   Type:    String
#   Default: curl
#   Desc:    Method to use to install netdata.  Options are 'curl' (default) and 'pkg'.
#
# * `package_names`
#   Type:    Array
#   Default: ['netdata']
#   Desc:    Names of package(s) used to install netdata.  You need to take care of building packages and adding them to repos yourself
#
# * `config_dir`
#   Type:    String
#   Default: $::netdata::install_dir/etc/netdata
#   Desc:    Configuration directory.
#
# * `plugins_dir`
#   Type:    String
#   Default: $::netdata::install_dir/usr/libexec/netdata/plugins.d
#   Desc:    Plugins directory.
#
# * `web_files_dir`
#   Type:    String
#   Default: $::netdata::install_dir/usr/share/netdata/web
#   Desc:    Web files directory.
#
# * `cache_dir`
#   Type:    String
#   Default: $::netdata::install_dir/var/cache/netdata
#   Desc:    Cache directory.
#
# * `log_dir`
#   Type:    String
#   Default: $::netdata::install_dir/var/log/netdata
#   Desc:    Log directory.
#
# * `debug_flags`
#   Type:    String
#   Default: 0x00000000
#   Desc:    Debug Flags (see https://github.com/firehol/netdata/wiki/Tracing-Options)
#
# * `memory_dedup`
#   Type:    Boolean
#   Default: true
#   Desc:    When true, netdata offers its memory for KMS deduplication.
#
# * `debug_logfile`
#   Type:    String
#   Default: debug.log
#   Desc:    Debug log file
#
# * `error_logfile`
#   Type:    String
#   Default: error.log
#   Desc:    Error log file
#
# * `access_logfile`
#   Type:    String
#   Default: access.log
#   Desc:    Access Log File
#
# * `memory_mode`
#   Type:    String
#   Default: save
#   Desc:    The mode for storing metrics. Options are save, map ram and none.
#
# * `web_mode`
#   Type:    String
#   Default: multi-threaded
#   Desc:    Web UI mode, options are none, single-threaded and multi-threaded.
#
# * `update_every`
#   Type:    Integer
#   Default: 1
#   Desc:    The frequency in seconds, for data collection.
#
# * `web_user`
#   Type:    String
#   Default: netdata
#   Desc:    Default netdata web user.
#
# * `web_group`
#   Type:    String
#   Default: netdata
#   Desc:    Default netdata web group.
#
# * `user`
#   Type:    String
#   Default: netdata
#   Desc:    Default netdata user.
#
# * `group`
#   Type:    String
#   Default: netdata
#   Desc:    Default netdata group.
#
# * `port`
#   Type:    Integer
#   Default: 19999
#   Desc:    The default port to listen for web clients.
#
# * `bind_to`
#   Type:    String
#   Default: *
#   Desc:    The IPv4 address and port to listen to.
#
# * `disconnect_webclient`
#   Type:    Integer
#   Default: 60
#   Desc:    The time in seconds to disconnect web clients after being totally idle.
#
# * `master`
#   Type:    Boolean
#   Default: false
#   Desc:    Set this to true for netdata to act as a master.
#
# * `remote_master`
#   Type:    String
#   Default: undef
#   Desc:    The Hostname of a remote netdata master.
#
# * `remote_master_port`
#   Type:    Integer
#   Default: 19999
#   Desc:    Port for remote netdata master.
#
# * `remote_master_apikey`
#   Type:    String
#   Default: undef
#   Desc:    This sets the API Key for talking to an upstream netdata. This must be a GUID.
#
# * `registry`
#   Type:    Boolean
#   Default: false
#   Desc:    Set to true in order for a netdata to act as a registry.
#
# * `registry_allowgroup`
#   Type:    String
#   Default: '*'
#   Desc:    List of subnets allowed to register.
#
# * `remote_registry`
#   Type:    String
#   Default: undef
#   Desc:    A central netdata that is configured with `isregistry`.
#
# * `remote_registry_port`
#   Type:    Integer
#   Default: 19999
#   Desc:    Port configured on the remote registry.
#
# Examples
# --------
#
# @basic example
#    class { '::netdata': }
#
# @master example
#    class { '::netdata': master => true }
#
# @slave example
#    class { '::netdata': master => 'netdata-master.example.com' }
# Authors
# -------
#
# Denver McAnally <denver.mcanally@gmail.com>
#
# Copyright
# ---------
#
# Copyright 2018 Denver McAnally
#
class netdata (

  Enum['present', 'absent']                       $ensure               = 'present',
  String                                          $version              = 'latest',
  Optional[String]                                $hostname             = undef,
  Integer                                         $history              = 3600,
  Optional[Stdlib::Absolutepath]                  $install_dir          = '/opt/netdata',
  Enum['curl', 'pkg']                             $install_method       = 'curl',
  Array[String]                                   $package_names        = ['netdata'],
  Stdlib::Absolutepath                            $config_dir           = '/etc/netdata',
  Stdlib::Absolutepath                            $plugins_dir          = '/usr/libexec/netdata/plugins.d',
  Stdlib::Absolutepath                            $web_files_dir        = '/usr/share/netdata/web',
  Stdlib::Absolutepath                            $cache_dir            = '/var/cache/netdata',
  Stdlib::Absolutepath                            $log_dir              = '/var/log/netdata',
  Stdlib::Absolutepath                            $service_filepath     = $::netdata::params::service_filepath,
  String                                          $service_filename     = $::netdata::params::service_filename,
  String                                          $service_filesrc      = $::netdata::params::service_filesrc,
  String                                          $service_filemode     = $::netdata::params::service_filemode,
  Optional[String]                                $debug_flags          = '0x00000000',
  Boolean                                         $memory_dedup         = true,
  String                                          $debug_logfile        = 'debug.log',
  String                                          $error_logfile        = 'error.log',
  String                                          $access_logfile       = 'access.log',
  Enum['save', 'map', 'ram','none']               $memory_mode          = 'save',
  Enum['none','single-threaded','multi-threaded'] $web_mode             = 'multi-threaded',
  Integer                                         $update_every         = 1,
  String                                          $web_user             = 'netdata',
  String                                          $web_group            = 'netdata',
  String                                          $user                 = 'netdata',
  String                                          $group                = 'netdata',
  Integer                                         $port                 = 19999,
  String                                          $bind_to              = '*',
  Integer                                         $disconnect_webclient = 60,
  Optional[String]                                $remote_master        = undef,
  Optional[Integer]                               $remote_master_port   = 19999,
  Optional[String]                                $remote_master_apikey = undef,
  Boolean                                         $master               = false,
  Boolean                                         $registry             = false,
  Optional[String]                                $remote_registry      = undef,
  Optional[Integer]                               $remote_registry_port = 19999,
  Optional[String]                                $registry_group       = undef,
  Optional[String]                                $registry_allowfrom   = '*',
  Hash[String, Hash]                              $streams              = {},
  Hash[String, Hash]                              $web_log              = {},

) inherits ::netdata::params {

  create_resources('netdata::stream', $streams)

  if $ensure == 'present' {
    class { '::netdata::install': }
    ~> class { '::netdata::config': }
    ~> class { '::netdata::plugin': }
    ~> class { '::netdata::service': }
  } elsif $ensure == 'absent' {
    if ($::operatingsystem == 'Ubuntu') and ($::operatingsystemrelease <= '14.10') {
      notice("${::operatingsystem} ${::operatingsystemmajrelease} uninstall not supported")
    } else {
      class { '::netdata::uninstall': }
    }
  }

}
