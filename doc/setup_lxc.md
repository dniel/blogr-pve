# LXC setup
I have used standard Debian 8 base images for the LXC containers.
I have assinged 1gb of ram, 1gb of swap space and 1gb of harddrive space for each container
and it seems to work pretty well.

#### First, To create a new LXC container
In proxmox perform the following steps to create a new container.
* Create a Debian 8 LXC container.
* I have used the following naming convention
for the node roles, the puppet scripts use this to map the role to the container.
    * app-[n] for the Node.js Express backend servers.
    * db-1 for the primary database.
    * db-2 for the standby database.
    * front-[n] for nginx reverse proxy servers that serve content in the dmz infront of the app-servers.
    * router-1 for the primary firewall.
    * router-2 for the standby firewall.
    * ci-[n] for Jenkins continuous integration server.
    * log-[n] for the Elasticsearch and Kibana backend for centralized logging.
    * login-[n] for the jump/login server that provide access to ssh on the other boxes.

* Assign correct virtual network device depending on which subnet you want.
* Assign vlan tag to network device. [See Network configuration](doc/setup_network.md)
* Assign 1gb of ram and swap
* Assign 1gb of storage space. This is the bare minimum that works for most container, increase to 2gb or 4gb where needed.

#### Then
##### Perform manual steps that must be performed on each virtual container.
* Log in to the new instance and run apt-get upgrade
* Copy eyaml private and public keys to /etc/puppetlabs/keys to be able to decrypt values
* Install GIT for cloning this repo,
* Install ca-certificates for https/ssl when cloning from https.
* Clone https://github.com/dniel/blogr-pve into /opt/pve
* run the *apply.sh* script in */opt/pve/apply.sh* to run the puppet and
depending on the hostname a role in the puppet script will be selected
for the container and executed.
