# Proxmox Virtual Environment

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with pve](#setup)
    * [What pve affects](#what-pve-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with pve](#beginning-with-pve)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)

## Overview

Puppet scripts for my home lab high-availability(HA) development environment.
Features
* hardware failover with virtualized proxmox cluster on two nodes
* load balanced frontend servers
* db servers with hot-standby
* load balanced node backend server

## Module Description

This module configure the linux servers in my virtual development environment.
It configures a pretty standard HA environment with double frontend servers with reverseproxies that
load balance infront of four backend servers that has been divided in two clusters and using a primary and 
hot-standby for stored state. Everything is devided in a DMZ and INTRA network for production like network
configuration.

## Setup

### Before using this modules, the following must be manually installed:

#### Download and install proxmox >4.2
* three virtual ethernet devices in proxmox.
* tag the virtual ethernet devices with vlan tag 2,3 and 4.

#### Download and install pfSense >2.3.1-RELEASE-p5 
* create a linux vm in proxmox, install pfsense.
* assign all virtual ethernet devices from proxmox to the qemu linux container.
* configure two new interfaces in pfsense, DMZ and INTRA on two new subnets.

## What pve affects

* network
* locale
* postgres
* nginx
* node
* git
* crontab
* timezone

### Setup Requirements

#### Needed packages for quick installation
* Install GIT for cloning this repo,
* Install ca-certificates for https/ssl when cloning from https.

### Beginning with pve

#### To install a new lxc container 
* create a Debian 8 LXC container.
* Name the container app-, front- or db- dependening of the role you want for the new container.
* Configure hieradata in this module for the new container
* Login to the new container, clone this repo and run apply.sh in the root folder.


## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

* Tested with Proxmox Virtual Environment 4.2-2/725d76f0.
* Virtual containers in Proxmox LXC installed with Debian 8.
* pfSense for firewall, gateway, routing, virtual ips of WAN, DMZ and LAN.
* A hardware network switch to route the vlans between different hardware nodes.
