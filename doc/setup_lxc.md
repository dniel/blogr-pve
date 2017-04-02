# Linux LXC container setup
I have used standard Debian 8 base images for the LXC containers.

#### First, To create a new LXC container
In proxmox perform the following steps to create a new container.
* Create a Debian 8 LXC container.
* I have used the following naming convention
for the node roles, the puppet scripts use this to map the role to the container.
    * [p|t|d]-app-[n] for the Node.js Express backend servers.
    * [p|t|d]-db-[n] for the primary database.
    * [p|t|d]-lb-[n] for nginx reverse proxy servers that serve content in the dmz infront of the app-servers.
    * router-1 for the primary firewall.
    * [p|t|d]-ci-[n] for Jenkins continuous integration server.
    * [p|t|d]-log-[n] for the Elasticsearch and Kibana backend for centralized logging.
    * [p|t|d]-chat-[n] for mattermost
    * [p|t|d]-cfg-[n] for consul

* The prefix p, t and d in the hostname is 
* Assign correct virtual network device depending on which subnet you want.
* Assign VLAN-tag to network device. [See Network configuration](doc/setup_network.md)
* Assign 1gb of ram.
* Assign 1gb of swap.
* Assign 4gb of storage space.

#### Then
##### Perform manual steps that must be performed on each virtual container.
* Copy the eyaml private and public keys to /etc/puppetlabs/keys to be able to decrypt values with *scp* command to the new LXC Container.
  * the keys must be generated for your own system beacuse they provide the encryption/decryption of
   eyaml files and should be held secret so that usernames and passwords and other sensitive info is readable only by you.
* Copy the hiera.yaml file to /etc/puppetlabs/puppet for configuration of hiera.

From the Proxmox server perform on the newly created container
```bash
$ lxc exec <containerid> -- apt-get update
$ lxc exec <containerid> -- apt-get upgrade
$ lxc exec <containerid> -- apt-get install git ca-certificates
$ lxc exec <containerid> -- git clone https://github.com/dniel/blogr-pve /opt/puppet/pve
$ lxc exec <containerid> -- /opt/puppet/pve/apply.sh
```

This will execute remote commands on the container to bootstrap the container with
initial puppet-scripts and depending on the hostname a role in the puppet script will be selected
for the container and executed.
