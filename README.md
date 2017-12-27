# iota-docker
This setup creates an IOTA full node with Docker based images. Other useful tools like Nelson and IPM are installed as well, but can be skipped.

At the moment the following docker images are used:
IOTA Node [Dockerhub](hhttps://hub.docker.com/r/rootlogin/iota-iri/) [Github](https://github.com/chrootLogin/iota-iri)
IOTA Peermanager [Dockerhub](https://hub.docker.com/r/ixidion/ipm/) [Github](https://github.com/akashgoswami/ipm)
Nelson [Dockerhub](https://hub.docker.com/r/romansemko/nelson.cli/) [Github](https://github.com/SemkoDev/nelson.cli)
nginx alpine (official image) [Docker](https://hub.docker.com/_/nginx/)

# Prerequisites
1. Setup a Server/VPS
   1. SSH daemon installed
   1. a non-privileged User
   1. Deny SSH root access
   1. Ensure that Python/Pip is installed
1. Create a SSH-Key and copy it to the server with `ssh-copy-id`
1. Installed version of Ansible DEV(!), cause of a bug with docker plugins in regular version See [30239](https://github.com/ansible/ansible/issues/30239)
```
pip install git+https://github.com/ansible/ansible.git@devel
```

# Run the playbook
* Adjust hosts.example, rename it to `hosts` and configure your servers.
* Resolve ansible dependencies
```
ansible-galaxy -f -r dependencies.yml
```
* Create the Passwordfile for nginx. Run ```./create_password.sh```
* Usage examples: **Default** Setup the node with defaults. Manual reboot is normally required after installing.
```
ansible-playbook -K -i hosts --vault-id="secret" site.yml
```
**Reboot**, behaves like default-setup, but reboots the machine if needed
```
ansible-playbook -K -i hosts --vault-id="secret" --extra-vars="reboot_for_upgrades=true" --extra-vars="iri_neighbors=<neighbors here>" --skip-tags "download_db" site.yml
```

## Other useful run options
Set fixed intial neighbors:
```--extra-vars="iri_neighbors=tcp://xyz.example:15600 udp://127.0.0.1:14600"```

Skip the download of the DB from iota.partners ```--skip-tags "download_db"``` The DB has a few GB and it is not necessary to download it each time the node is recreated.

The following Tags are defined:
* iri - Installation of IRI with download of DB by default.
* download_db - Download of the IRI db from iota.partners and extraction to IRI folder.
* ipm - Installs the [IOTA Peermanager](https://github.com/akashgoswami/ipm). It is bound to localhost by default.
* nginx - Installs nginx to reverse proxy IPM. TODO Implement htaccess. So not much function at the moment.
* nelson - Installs [Nelson]() for automatic discovery and management of neighbors.

## Tips & Tricks
IPM, IRI (API) is only bound to localhost for security reasons. Setup an SSH tunneling.
```
Host iota
        HostName <hostname>
        User <username>
        PreferredAuthentications publickey
        IdentityFile /Users/<localusername>/.ssh/<ssh_private_key>
        UseKeychain yes
        AddKeysToAgent yes
        LocalForward 127.0.0.1:8888 127.0.0.1:8888
        LocalForward 127.0.0.1:14265 127.0.0.1:14265
```

Then just run: ```ssh iota``` and point your browser to ```http://localhost:8888``` and your curl/Postman to ```localhost:14265```

# How to setup IOTA without Docker
If Docker is not an option for you and want to install IOTA directly on bare metal or a VPS, then you should definitely checkout [IRI Playbook](https://github.com/nuriel77/iri-playbook).
