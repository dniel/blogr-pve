# Proxmox Virtual Environment
##### Puppet scripts for my home lab high-availability(HA) development environment.
My home lab environment for software development and infrastructure
that has a production like configuration that I use to learn and
practice on DevOps and software development. The setup is similar
to and handle some of the complexity that a IT-department would
need to meet the demands of a production, test and dev environment.

It configures a pretty standard high-availability environment with a
pair of reverse proxies that load balance in front of four backend
servers that has been divided in two clusters and using a primary
and hot-standby for stored state.

The network has been
separated into network zones for dmz and a internal corporate
network + more to emulate a production like environment.

##### Features
* clustered proxmox virtual environment on three machines.
* hardware failover with virtualized linux containers deployed on the proxmox cluster.
* firewall with failover.
* secured network, divided into separate vlan zones.
* database with failover.
* load balanced frontend servers.
* load balanced node backend server.
* immutable virtual servers.
* a sample web application.

## Hardware
Three retired work laptops, Lenovo W520 and W530 with 16GB ram
 and old school spinning hard drives connected with a Cisco
 switch with VLAN support, SG 200-08, for directing network
 traffic between them.

![alt tag](doc/machines.jpg)

## Proxmox cluster on three nodes.
A screenshot from the Proxmox Web Admin. The three machines has
been added to the same cluster and can be managed through the
same admin console.

![alt tag](doc/pve.jpg)

##### Virtual machines overview with networks
This is how is looks like if modelled with Archimate and Archi.
I have modelled just the virtual machines, the networks and firewalls
that connect them.

![alt tag](doc/virtual.jpg)

## The sample application that is deployed
Is a very simple React application [Blogr](https://github.com/dniel/blogr-workshop)
that uses a Node Express backend and a PostgreSQL database for
persistence. Right now its deployed using the same puppet script
that install the configuration and system software but this
eventually be handled by Jenkins Pipeline.

## Installation
#### First steps
##### Create VLANs in the network switch
Name the vlans
* 2=DMZ
* 3=INTRA
* 4=SYNC
* 5=DEV

DMZ is the internet facing vlan.
INTRA is the internal corporate network.
SYNC is the network pfSense instances uses to sync failover state.
DEV is the development infrastructure network, where Jenkins and ELK is configured.

The network setup use subnets 10.0.1.x, 10.0.2.x, 10.0.3 and 10.0.4.x

##### Download and install proxmox
Install Proxmox on all three laptops.
* Proxmox version > 4.2
* Create four virtual ethernet devices in proxmox.
* Tag the virtual ethernet devices with vlan tag 2,3,4 and 5

##### Download, install and configure pfSense
* pfSense version > 2.3.1-RELEASE-p5
* Create a linux VM in Proxmox, install pfsense.
* Assign all virtual ethernet devices from proxmox to the qemu linux container.
* Create four interfaces in pfsense, DMZ and INTRA on two new subnets.

##### To create a new LXC container
* Create a Debian 8 LXC container.
* Assign correct virtual network device depending on which vlan you want your container.
* Assign vlan tag to network device (dmz=2, intra=3, dev=4)
* Configure Hiera-data in this module for the new container

I have used standard Debian 8 base images for the LXC containers.
I have assinged 1gb of ram, 1gb of swap space and 1gb of harddrive space for each container
and it seems to work pretty well.

I have used in the puppet scripts the following naming convention
for the node roles.
* app-[n] for the Node.js Express backend servers.
* db-1 for the primary database.
* db-2 for the standby database.
* front-[n] for nginx reverse proxy servers that serve content in the dmz infront of the app-servers.
* router-1 for the primary firewall.
* router-2 for the standby firewall.
* ci-[n] for Jenkins continuous integration server.
* log-[n] for the Elasticsearch and Kibana backend for centralized logging.

#### Then
##### perform manual steps that must be performed on each virtual container.
* Install GIT for cloning this repo,
* Install ca-certificates for https/ssl when cloning from https.
* Clone https://github.com/ with puppet scripts as /opt/pve
* run the *apply.sh* script in */opt/pve/apply.sh* to run the puppet and
depending on the hostname a role in the puppet script will be selected
for the container and executed.


## The Puppet Module


## Limitations
* Tested with Proxmox Virtual Environment 4.2-2/725d76f0.
* Virtual containers in Proxmox LXC installed with Debian 8.
* pfSense for firewall, gateway, routing, virtual ips of WAN, DMZ and LAN.
* A hardware network switch to route the vlans between different hardware nodes.
* Will not configure proxmox or pfsense, both must be manually installed and configured.

### Future development
* ELK collecting the log-files from all servers and applications.
* NAS, Network storage using iSCSI drive with multiple bays for configuring RAID failover on hard drives.
* Configure proxmox with puppet
* Configure pfSense with puppet
* Jenkins2 build server with Pipeline for deploying the Node Application to dev, test and production.
* Secured and hardened jump/login server to give access all virtal servers from remote login.