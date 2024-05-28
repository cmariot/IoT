#!/bin/sh

# Install k3s on the server
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode=644 --flannel-iface="eth1"

kubectl apply -f /vagrant/confs/deployment.yaml
kubectl apply -f /vagrant/confs/service.yaml