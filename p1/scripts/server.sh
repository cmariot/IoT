#!/bin/sh

<<<<<<< HEAD
# Install k3s on the server
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode=644
=======
# # Install k3s on the server
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode=644 --node-external-ip="192.168.56.110" --flannel-iface="eth1"
>>>>>>> 8055e2a29d6588d4ea6726db97cf5d3a8aae6c96


# Share the k3s server-token with the host machine
mkdir -p /vagrant/confs
sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/confs/token
