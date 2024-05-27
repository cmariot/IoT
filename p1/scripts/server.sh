#!/bin/sh

# Install k3s on the server
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode=644 --flannel-iface="eth1"


# Share the k3s server-token with the host machine
mkdir -p /vagrant/confs
sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/confs/token
