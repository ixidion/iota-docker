# iota-docker
This setup creates an IOTA full node with Docker based images. Other useful tools for monitoring and management are available as well.

At the moment the following docker images are used:
IOTA Node [Dockerhub](https://hub.docker.com/r/bluedigits/iota-node/)
IOTA Peermanager [Dockerhub](https://hub.docker.com/r/ixidion/ipm/) [Github](https://github.com/akashgoswami/ipm)

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
1. Adjust hosts.example, rename it to hosts and configure your hosts.
1. Resolve ansible dependencies
```
ansible-galaxy -f -r dependencies.yml
```
1. Usage examples: **Default** Setup the node with defaults. Manual reboot is normally required after installing.
```
ansible-playbook -i hosts --ask-become sites.yml
```
**Reboot**, like default but reboots the machine if needed
```
ansible-playbook -i hosts --ask-become --extra-vars="reboot_for_upgrades=true" --extra-vars="iri_neighbors=tcp://vmi154313.contaboserver.net:15600 tcp://vmi154543.contaboserver.net:15600 tcp://miota.zapto.org:1339 tcp://vmi153897.contaboserver.net:15600 tcp://draugr.iotanodes.eu:15600 tcp://h2539110.stratoserver.net:15600 tcp://46.101.111.142:15600 tcp://node.your-iota.de:1337 udp://104.158.211.141:14701 tcp://euve259512.serverprofi24.de:15600 tcp://ec2-52-210-154-106.eu-west-1.compute.amazonaws.com:15600 tcp://185.206.144.75:15600" --skip-tags "download_db" sites.yml
```

## Other useful run options
Set fixed intial neighbors:
```--extra-vars="iri_neighbors=tcp://xyz.example:15600 udp://127.0.0.1:14600"

Skip the download of the DB from iota.partners ```--skip-tags "download_db"``` The DB has a few GB and it is not necessary to download it each time the node is recreated.

The following Tags are defined:
* iri - Installation of IRI with download of DB by default.
* download_db - Download of the IRI db from iota.partners and extraction to IRI folder.
* ipm - Installs the [IOTA Peermanager](https://github.com/akashgoswami/ipm). It is bound to localhost by default.
* nginx - Installs NGIX to reverse proxy IPM. TODO Implement htaccess. So not much function at the moment.
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
