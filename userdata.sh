#!/bin/bash
set -xe

sudo yum update -y

# install git
sudo yum install git -y

# Install Docker on Amazon Linux 2
sudo amazon-linux-extras enable docker
sudo yum install -y docker

sudo systemctl start docker
sudo systemctl enable docker

usermod -aG docker ec2-user

# Install kubectl
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/
sudo chown ec2-user:ec2-user /usr/local/bin/kubectl

# Install conntrack (required for minikube)
sudo yum install -y conntrack

# Install minikube
sudo curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo chmod +x minikube
sudo mv minikube /usr/local/bin/
sudo chown ec2-user:ec2-user /usr/local/bin/minikube
# Start minikube as ec2-user using none driver (bare metal)
sudo -i -u ec2-user bash -c 'minikube start --driver=none'

# Ensure /usr/local/bin is in ec2-user's PATH
sudo grep -qxF 'export PATH=$PATH:/usr/local/bin' /home/ec2-user/.bash_profile || echo 'export PATH=$PATH:/usr/local/bin' >> /home/ec2-user/.bash_profile
sudo chown ec2-user:ec2-user /home/ec2-user/.bash_profile
