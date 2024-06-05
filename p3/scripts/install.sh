#!/bin/bash


install_docker() {

    echo "Installing Docker"

    # Uninstall all conflicting packages
    for pkg in docker.io \
               docker-doc \
               docker-compose \
               docker-compose-v2 \
               podman-docker \
               containerd \
               runc;
        do sudo apt-get remove $pkg;
    done

    # Add Docker's official GPG key:
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update

    # Install Docker
    sudo apt-get install docker-ce \
                         docker-ce-cli \
                         containerd.io \
                         docker-buildx-plugin \
                         docker-compose-plugin -y

    # PostInstall : use docker without sudo
    sudo usermod -aG docker $USER
    newgrp docker

    echo "Docker installed successfully"

}


install_kubectl() {

    echo "Installing Kubectl"

    # Download the latest release:
    if [ "$(uname -m)" = "aarch64" ]; then
        curl -LOs "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
    else
        curl -LOs "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    fi

    # Make the download executable and put it in the PATH
    chmod +x kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl

    echo "Kubectl installed successfully"

}


install_k3d() {

    echo "Installing K3D"

    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

    echo "K3D installed successfully"

}


install_argocd() {

    echo "Installing ArgoCD"

    # Install ArgoCD as a kubernetes service
    sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

    # Change the service type to LoadBalancer
    sudo kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

    # Wait for the pods to be ready
    sudo kubectl wait --for=condition=Ready pods --all --timeout=3600s -n argocd

    cmd="sudo kubectl port-forward svc/argocd-server -n argocd 8080:443 --address="0.0.0.0"";
    ${cmd} &>/dev/null & disown;

    echo "ArgoCD installed successfully"


    password=$(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
    echo "ArgoCD URL: https://192.168.56.110:8080"
    echo "ArgoCD username: admin"
    echo "ArgoCD password: $password"

}


main() {

    sudo apt-get update

    # install Docker (required by K3D)
    install_docker

    # install Kubectl (required by K3D)
    install_kubectl

    # install K3D
    install_k3d

    # Create a k3d cluster
    sudo k3d cluster create iotcluster -p 8888:8888@loadbalancer

    # Create two namespaces: argocd and dev
    sudo kubectl create namespace argocd
    sudo kubectl create namespace dev

    

    # Install ArgoCD
    install_argocd

    # Setup CI/CD pipeline
    sudo kubectl apply -f /vagrant/confs/argocd_app.yaml

}


main