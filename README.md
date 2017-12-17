# iota-docker
This setup creates an IOTA full node with Docker based images. Other useful tools for monitoring and management are available as well.

At the moment the following docker images are used:
IOTA Node [Dockerhub](https://hub.docker.com/r/bluedigits/iota-node/)
IOTA Peermanager [Dockerhub](https://hub.docker.com/r/ixidion/ipm/) [Github](https://github.com/akashgoswami/ipm)

## Usage Instructions
1. Setup a Server/VPS
   1. Install SSH
   1. Setup a non-privileged User
   1. Deny SSH root access
   1. Ensure that Python is installed
1. Create a SSH-Key and copy it to the server with `ssh-copy-id`
1. Install on you local machine ansible DEV(!) version, cause of a bug with docker plugins in regular version
1. Adjust hosts.example and rename it to hosts
1. Execute install_docker.sh

```
usage: install_docker.sh [OPTIONS]
      --install-docker       installs docker daemon on a remote host with Ansible
      --download-db          trigger download and renew of DB from http://iota.partners
      --extract-only         extract tarball only. In case the download succeded, but not the extraction.
      --compose              runs docker-compose to setup/renew the container
      --help                 print this help
```

If you have problems with pip, you have to adjust `pip_package_name` variable in `ansible/install_docker.yml`

## How to setup IOTA without Docker
If Docker is not an option for you and want to install IOTA directly on bare metal or a VPS, then you should definitely checkout [IRI Playbook](https://github.com/nuriel77/iri-playbook).
