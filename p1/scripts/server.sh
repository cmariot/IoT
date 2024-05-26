#!/bin/sh

# Set the timezone to Europe/Paris
sudo timedatectl set-timezone Europe/Paris

# Add the k3s server worker to the /etc/hosts file
sudo echo "192.168.56.111 cmariotSW" >> /etc/hosts

# Install k3s on the server
# curl -sfL https://get.k3s.io | sh -s - server --flannel-iface=eth1 --write-kubeconfig-mode 644

# Share the k3s server-token with the host machine
# mkdir -p /vagrant/confs
# sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/confs/token
