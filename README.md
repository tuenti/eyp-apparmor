# apparmor

**AtlasIT-AM/eyp-apparmor**: [![Build Status](https://travis-ci.org/AtlasIT-AM/eyp-apparmor.png?branch=master)](https://travis-ci.org/AtlasIT-AM/eyp-apparmor)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What barman affects](#what-barman-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with barman](#beginning-with-barman)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)
    * [Contributing](#contributing)

## Overview

Manages AppArmor

## Module Description

Allows you to enforce globally a mode for AppArmor:
* complain
* enforce
* disable (by default)


## Setup

### What apparmor affects

Installs apparmor-utils to be able to manage AppArmor

### Setup Requirements

This module requires pluginsync enabled

### Beginning with apparmor

The very basic steps needed for a user to get the module up and running.

If your most recent release breaks compatibility or requires particular steps
for upgrading, you may wish to include an additional section here: Upgrading
(For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

Tested on:
* Ubuntu 14.04

## Development

We are pushing to have acceptance testing in place, so any new feature should
have some test to check both presence and absence of any feature

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
