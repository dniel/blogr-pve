# Network setup
### Create the VLANS and assign to the correct ports on your switch.
Prepare communication between the laptops your switch/router
be configured to route a set of VLANS.

| VLAN          | Description  |
| ------------- |------------- |
| DMZ           | the internet facing services.            |
| INTRA         | the internal corporate network with production applications.            |
| RESOURCES     | the infrastructure network, where NAS, Jenkins, ELK etc. is configured.             |
| DEVELOPMENT   | the development network, contain test servers and devserver for development. |
| ADMIN         | where all administrative interfaces, switches, routers, hosts etc. are placed for securing who can access   |
| PUBLIC        | when connecting by WiFi or wired with client devices, laptops, smartphones, tablets etc.             |

### Diagram
![network_diagram](networks.png)


### DMZ, demilitarized zone
From [Wikipedia](https://en.wikipedia.org/wiki/DMZ_(computing))
> In computer security, a DMZ or demilitarized zone (sometimes referred to as a perimeter network)
> is a physical or logical subnetwork that contains and exposes an organization's external-facing
> services to an untrusted network, usually a larger network such as the Internet.
> The purpose of a DMZ is to add an additional layer of security to an organization's
> local area network (LAN); an external network node can access only what is exposed in the DMZ,
> while the rest of the organization's network is firewalled.

### INTRA, the internal organisation's network.
The internal network contains application used in production that should be used in daily production
for the organisation. Could be CRM systems, Order management etc. and other software used by the 
organisation.

### RESOURCES, support tools for the organisation.
The resources network contain support tools that are used by the organisation. Email servers, File Servers,
Chat servers and other software that supports the organisation.

### DEV, the internal network for the development departement.
The development department needs its own services to be able produce solutions. They need dev-servers, 
 test-servers, quality assurance-servers and other servers they need to do their development on.
 
### ADMIN, the administrative network
An extra sensitive network where the operational and infrastructure responsible team may access services
that they use to configure the infrastructure. For example virtualization hosts manager, switches, firewalls
and routers. This network should be especially secured because it provide access to some very sensitive 
services.

### PUBLIC, unprivileged network access
A unprivileged network that users may connect to with cable or WiFi access point.
It should not provide any sensitive services, and act like a guest network.