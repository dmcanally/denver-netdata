# denver-netdata

[![Build Status](https://travis-ci.org/dmcanally/denver-netdata.svg?branch=master)](https://travis-ci.org/dmcanally/denver-netdata)
[![Code Coverage](https://coveralls.io/repos/github/dmcanally/denver-netdata/badge.svg?branch=master)](https://coveralls.io/github/dmcanally/denver-netdata)
[![Puppet Forge](https://img.shields.io/puppetforge/v/denver/netdata.svg)](https://forge.puppetlabs.com/denver/netdata)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/denver/netdata.svg)](https://forge.puppetlabs.com/denver/netdata)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/denver/netdata.svg)](https://forge.puppetlabs.com/denver/netdata)


#### Table of Contents

1. [Description](#description)
1. [Setup](#setup)
    * [Setup requirements](#setup-requirements)
1. [Usage](#usage)
    * [Basic usage](#basic-usage)
    * [Advanced usage](#advanced-use-cases)
    * [Plugins](#plugins)
    * [Parameters](#parameters)
1. [Limitations](#limitations)
1. [Development](#development)

## Description

This module deploys and configures netdata. Netdata is a system for distributed real-time performance and health monitoring. More can be found on netdata at [firehol/netdata](https://github.com/firehol/netdata). 

## Setup

### Setup requirements

This module requires you have a compatible OS and a functioning puppet infrastructure.

## Usage

### Basic  usage
To deploy and configure default netdata...
```puppet
class {'::netdata': }
```

To remove a deployed netdata...
```puppet
class {'::netdata': ensure => 'absent'}
```
Note, `ensure => 'absent'` is not currently supported on Ubuntu 14.04 due to the way puppet manages upstart.

### Advanced useage
To configure netdata as a Slave. Note, the GUID displayed here is just an example.
```puppet
class {'::netdata':
  remote_master        => 'netdata-master.example.com',
  remote_master_apikey => '9a83b18a-5cdb-4baf-8958-ad291ab781d3',
}
```
`netdata::stream`
To configure netdata as a Master
```puppet
class {'::netdata':
  master => true,
}
```
In order for netdata metrics to stream to a master, you must define a netdata stream API key. You can generate a GUID with uuidgen. More information can be found on netdata replication [here](https://github.com/firehol/netdata/wiki/Replication-Overview).
```puppet
netdata::stream {'9a83b18a-5cdb-4baf-8958-ad291ab781d3': }
```

To configure netdata as a Proxy
```puppet
class {'::netdata':
  master               => true,
  remote_master        => 'netdata-master.example.com',
  remote_master_apikey => '9a83b18a-5cdb-4baf-8958-ad291ab781d3',
}

netdata::stream {'9a83b18a-5cdb-4baf-8958-ad291ab781d3': }
```
### Plugins
`netdata::plugin::bind_rndc` <br/>
This plugin tracks bind rndc stats. More [here](https://github.com/firehol/netdata/tree/master/python.d#bind_rndc). <br/>
```puppet
netdata::plugin::bind_rndc {'example.com': }
```
 * `update` <br/>
   Optional. Data collection frequency. <br/>
 * `priority` <br/>
   Optional. Order of the dashboard. <br/>
 * `retries` <br/>
   Optional. Number of restoration attempts. <br/>
 * `detect_retry`<br/>
   Optional. re-detect interval in seconds. <br/>

`netdata::plugin::web_log` <br/>
This plugin supports apache, apache_cache, nginx, gunicorn, and squid. More [here](https://github.com/firehol/netdata/tree/master/python.d#web_log). <br/>
```puppet
netdata::plugin::web_log {'example.com':
  logfile => '/var/log/nginx/example.com',
}
```
 * `type` <br/>
   Optional. Type of service generating the log file. <br/>
 * `logfile` <br/>
    Required. This should be the full path of the logfile being monitored. <br/>


### Class Parameters

 * `history`<br/>
   Default: 3600<br/>
   Desc: The number of entries the netdata daemon will by default keep in memory for each chart dimension.<br/>

 * `debug_flags`<br/>
   Desc:    Debug Flags. See [more info](see https://github.com/firehol/netdata/wiki/Tracing-Options).<br/>

 * `memory_mode`<br/>
   Default: save<br/>
   Desc:    The mode for storing metrics. Options are save, map ram and none.<br/>

 * `web_mode`<br/>
   Default: multi-threaded<br/>
   Desc:    Web UI mode, options are none, single-threaded and multi-threaded.<br/>

 * `update_every`<br/>
   Default: 1<br/>
   Desc:    The frequency in seconds, for data collection.<br/>

 * `port`<br/>
   Default: 19999<br/>
   Desc:    The default port to listen for web clients.<br/>

 * `bind_to`<br/>
   Default: * <br/>
   Desc:    The IPv4 address and port to listen to.<br/>

 * `master`<br/>
   Default: false<br/>
   Desc:    Set this to true for netdata to act as a master.<br/>

 * `remote_master`<br/>
   Default: undef<br/>
   Desc:    The Hostname of a remote netdata master.<br/>

 * `remote_master_port`<br/>
   Default: 19999<br/>
   Desc:    Port for remote netdata master.<br/>

 * `remote_master_apikey`<br/>
   Default: undef<br/>
   Desc:    This sets the API Key for talking to an upstream netdata. This must be a GUID. A netdata master must have a matching GUID defined with netdata::stream.<br/>

 * `registry`<br/>
   Default: false<br/>
   Desc:    Set to true in order for a netdata to act as a registry.<br/>

 * `registry_allowgroup`
   Default: * <br/>
   Desc:    List of subnets allowed to register.<br/>

 * `remote_registry`<br/>
   Default: undef<br/>
   Desc:    A central netdata that is configured with `registry => true`.<br/>

 * `remote_registry_port`<br/>
   Default: 19999<br/>
   Desc:    Port configured on the remote registry.<br/>

## Limitations

This module is tested with CentOS 6 and 7, Ubunu LTS 14.04, and 16.04. There is no guarantee that this module will work for other operating systems.

## Development

This module is currently maintained by Denver McAnally (denver.mcanally@gmail.com). Please feel free to contribute. When doing so, please be sure to provide appropriate test coverage.
Please see puppetlabs [contribution guide](https://docs.puppetlabs.com/forge/contributing.html) for more information. 

Netdata is developed and maintained at [firehol/netdata](https://github.com/firehol/netdata).
