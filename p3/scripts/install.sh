#!/bin/sh


install_docker() {

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


install_k3d() {

    # Install K3D
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

    echo "K3D installed successfully"

}

# install K3D


main() {

    # install Docker (required by K3D)
    install_docker

    # install K3D
    install_k3d

}

main