#!/bin/sh


install_docker() {

    export DEBIAN_FRONTEND=noninteractive

    # Uninstall all conflicting packages
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc;
        do sudo apt-get remove $pkg;
    done

    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl -y
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
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

    # PostInstall : use docker without sudo
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker

    echo "Docker installed successfully"

}


install_kubectl() {

    # Install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    chmod +x kubectl
    mkdir -p ~/.local/bin
    mv ./kubectl ~/.local/bin/kubectl

    echo "export PATH=$PATH:~/.local/bin" >> ~/.bashrc
    source ~/.bashrc

    echo "Kubectl installed successfully"

}


install_k3d() {

    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

    echo "K3D installed successfully"

}


install_argocd() {

    # Install ArgoCD

    sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

    sudo kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

    # sudo kubectl wait --for=condition=Ready pods --all --timeout=600s -n argocd

    sudo kubectl port-forward svc/argocd-server -n argocd 8080:443 --address="0.0.0.0" > /dev/null 2>&1 & echo "ArgoCD installed successfully"


    # Install ArgoCD CLI

    curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
    rm argocd-linux-amd64

    echo "ArgoCD CLI installed successfully"

    # Get ArgoCD password
    initial_password=$(\
        sudo argocd admin initial-password -n argocd | head -n 1\
    )

    # Generate a new password
    new_password=$(openssl rand -base64 32)

    echo "ArgoCD username: admin"
    echo "ArgoCD password: $initial_password"

    argocd login localhost:8080 --username admin --password $initial_password --insecure

    argocd account update-password --current-password $initial_password --new-password $new_password

    echo "ArgoCD password updated successfully"

    echo "Your new ArgoCD password is: $new_password"

}


setup_pipeline() {

    sudo kubectl config set-context --current --namespace=argocd

    cd /vagrant/confs/app

    argocd app create victory-royale \
        --repo https://github.com/cmariot/app_iot_cmariot.git \
        --path /vagrant/confs/app \
        --dest-server https://kubernetes.default.svc \
        --dest-namespace dev

    sleep 10

    argocd app set victory-royale --sync-policy automated

    argocd app sync victory-royale

    sudo kubectl port-forward services/victory-royale 8888 \
        -n dev --address="0.0.0.0" > /dev/null 2>&1 & \
        echo "CI/CD pipeline setup successfully"
}


main() {

    # install Docker (required by K3D)
    install_docker

    # install Kubectl (required by K3D)
    install_kubectl

    # install K3D
    install_k3d

    # Create a k3d cluster
    sudo k3d cluster create iotcluster

    # Create two namespaces: argocd and dev
    kubectl create namespace argocd
    kubectl create namespace dev

    # Install ArgoCD
    install_argocd

    # Setup CI/CD pipeline
    setup_pipeline

}

main