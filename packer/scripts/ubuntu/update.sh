#!/bin/bash -eux

# Update the package list
apt-get update

# Upgrade all installed packages incl. kernel and kernel headers
apt-get -y upgrade linux-server linux-headers-server

# ensure the correct kernel headers are installed
apt-get -y install linux-headers-$(uname -r)

# install ansible for extra provisioning
apt-get -y install ansible
mkdir -p /tmp/packer-provisioner-ansible-local/vars
touch /tmp/packer-provisioner-ansible-local/vars/local.yml
chmod -R 777 /tmp/packer-provisioner-ansible-local

# update package index on boot
cat <<EOF > /etc/init/refresh-apt.conf
description "update package index"
start on networking
task
exec /usr/bin/apt-get update
EOF
