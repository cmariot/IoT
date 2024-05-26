#!/bin/sh

# Set the timezone to Europe/Paris
sudo timedatectl set-timezone Europe/Paris

# Add the k3s server to the /etc/hosts file
sudo echo "192.168.56.110 wloS" >> /etc/hosts

# Install k3s on the server worker
# curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=$(cat /vagrant/confs/token) sh -s - agent --flannel-iface=eth1
