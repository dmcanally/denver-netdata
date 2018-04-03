# denver-netdata

[![Build Status](https://travis-ci.org/dmcanally/denver-netdata.svg?branch=master)](https://travis-ci.org/dmcanally/denver-netdata)
[![Code Coverage](https://coveralls.io/repos/github/dmcanally/denver-netdata/badge.svg?branch=master)](https://coveralls.io/github/dmcanally/denver-netdata)
[![Puppet Forge](https://img.shields.io/puppetforge/v/denver/netdata.svg)](https://forge.puppetlabs.com/denver/netdata)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/denver/netdata.svg)](https://forge.puppetlabs.com/denver/netdata)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/denver/netdata.svg)](https://forge.puppetlabs.com/denver/netdata)


#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with netdata](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with netdata](#beginning-with-netdata)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module deploys and configured netdata. More can be found on netdata at (https://github.com/firehol/netdata). 

## Setup

### Setup requirements

This module requires you have a compatible OS and a functioning puppet infrastructure.

### Beginning with netdata

To deploy and configure default netdata...
```puppet
class {'::netdata': }
```

## Usage

### Advanced use cases
To configure netdata as a Slave. Note, the GUID displayed here is just an example.
```puppet
class {'::netdata':
  remote_master        => 'netdata-master.example.com',
  remote_master_apikey => '9a83b18a-5cdb-4baf-8958-ad291ab781d3',
}
```

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

### Parameters

 * `history`

   Type:    Integer
   Default: 3600
   Desc:    The number of entries the netdata daemon will by default keep in memory for each chart dimension. 

 * `debug_flags`

   Type:    String
   Default: 0x00000000
   Desc:    Debug Flags (see https://github.com/firehol/netdata/wiki/Tracing-Options)

 * `debug_logfile`

   Type:    String
   Default: debug.log
   Desc:    Debug log file

 * `error_logfile`

   Type:    String
   Default: error.log
   Desc:    Error log file

 * `access_logfile`

   Type:    String
   Default: access.log
   Desc:    Access Log File

 * `memory_mode`

   Type:    String
   Default: save
   Desc:    The mode for storing metrics. Options are save, map ram and none.

 * `web_mode`

   Type:    String
   Default: multi-threaded
   Desc:    Web UI mode, options are none, single-threaded and multi-threaded.

 * `update_every`

   Type:    Integer
   Default: 1
   Desc:    The frequency in seconds, for data collection.

 * `port`

   Type:    Integer
   Default: 19999
   Desc:    The default port to listen for web clients.

 * `bind_to`

   Type:    String
   Default: *
   Desc:    The IPv4 address and port to listen to.

 * `master`

   Type:    Boolean
   Default: false
   Desc:    Set this to true for netdata to act as a master.

 * `remote_master`

   Type:    String
   Default: undef
   Desc:    The Hostname of a remote netdata master.

 * `remote_master_port`

   Type:    Integer
   Default: 19999
   Desc:    Port for remote netdata master.

 * `remote_master_apikey`

   Type:    String
   Default: undef
   Desc:    This sets the API Key for talking to an upstream netdata. This must be a GUID. A netdata master must have a matching GUID defined with netdata::stream.

 * `registry`

   Type:    Boolean
   Default: false
   Desc:    Set to true in order for a netdata to act as a registry.

 * `registry_allowgroup`

   Type:    String
   Default: *
   Desc:    List of subnets allowed to register.

 * `remote_registry`

   Type:    String
   Default: undef
   Desc:    A central netdata that is configured with `isregistry`.

 * `remote_registry_port`

   Type:    Integer
   Default: 19999
   Desc:    Port configured on the remote registry.

## Limitations

This module is tested with CentOS 6 and 7, Ubunu LTS 14.04, 16.04, and 18.04. There is no guarantee that this module will work for other operating systems.

## Development

This module is currently maintained by Denver McAnally (denver.mcanally@gmail.com). Please feel free to contribute. When doing so, please be sure to provide appropriate test coverage.
Please see puppetlabs [contribution guide](https://docs.puppetlabs.com/forge/contributing.html) for more information. 
