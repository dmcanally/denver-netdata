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
```ruby
class {'::netdata': }
```

## Usage

To configure netdata as a Slave
```ruby
class {'::netdata':
  remote_master   => 'netdata-master.example.com',
  remote_master_apikey => '9a83b18a-5cdb-4baf-8958-ad291ab781d3',
}
```

To configure netdata as a Master
```ruby
class {'::netdata':
  master => true,
}

netdata::stream {'9a83b18a-5cdb-4baf-8958-ad291ab781d3': }
```

To configure netdata as a Proxy
```ruby
class {'::netdata':
  master          => true,
  remote_master   => 'netdata-master.example.com',
  remote_master_apikey => '9a83b18a-5cdb-4baf-8958-ad291ab781d3',
}

netdata::stream {'9a83b18a-5cdb-4baf-8958-ad291ab781d3': }
```

## Limitations

This module is tested with CentOS 6 and 7, Ubunu LTS 14.04, 16.04, and 18.04. There is no guarantee that this module will work for other operating systems.

## Development

This module is currently maintained by Denver McAnally (denver.mcanally@gmail.com). Please feel free to contribute. When doing so, please be sure to provide appropriate test coverage.
Please see puppetlabs [contrinution guide](https://docs.puppetlabs.com/forge/contributing.html) for more information. 
