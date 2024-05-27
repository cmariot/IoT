#!/bin/sh

# Install k3s on the server worker
curl -sfL https://get.k3s.io | sh -s - agent --server=https://192.168.56.110:6443 --token=$(cat /vagrant/confs/token) --node-ip=192.168.56.111

