# selinux-dockersock

A nice trick with docker is to mount the docker daemon's unix socket
into a container, so that container can act as a client to the docker
daemon it is running under, e.g.:

    docker run ... -v /var/run/docker.sock:/var/run/docker.sock

But this doesn't work with Fedora or RHEL as the host because of their
use of SELinux to harden containers.  When the docker client attempts
to access `/var/run/docker.sock` within the container, you'll get
"Permission denied" errors.

This repo contains a small SELinux module that fixes this issue,
allowing containers to access the socket.

## Support RHEL/CentOS 7

This repo made to document a process of creating SELinux module for RHEL/CentOS 7. If you need 
support for previous versions please use instruction from the original repo. 

## Usage

Make sure you have the prerequisite SELinux utilities by doing (on
RHEL/CentOS/Fedora/etc.):

    dnf install policycoreutils policycoreutils-python-utils checkpolicy

Then as root, just do

    make

Or if you are paranoid, without being root you can do

    make dockersock.pp

to build the SELinux policy module package, and then load it as root
with

    semodule -i dockersock.pp

Should you ever wish to remove the module, do

    semodule -r dockersock  

## Module for Systemd

In case you have issue with systemd need access to docker.sock too use module `systemd_docker_sock.te`.