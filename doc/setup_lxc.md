# LXC setup
#### To create a new LXC container
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

### Then
#### perform manual steps that must be performed on each virtual container.
* Install GIT for cloning this repo,
* Install ca-certificates for https/ssl when cloning from https.
* Clone https://github.com/ with puppet scripts as /opt/pve
* run the *apply.sh* script in */opt/pve/apply.sh* to run the puppet and
depending on the hostname a role in the puppet script will be selected
for the container and executed.
