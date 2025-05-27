#!/bin/bash
set +xe

# Update system
sudo yum update -y

# Install Git
sudo yum install -y git
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
sudo chown ec2-user:ec2-user /usr/local/bin/kubectl

# Install conntrack
sudo yum install -y conntrack

# Install Minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/
sudo chown ec2-user:ec2-user /usr/local/bin/minikube

# Defer minikube startup to login (optional, safer)
echo 'if ! minikube status &>/dev/null; then minikube start --driver=none; fi' >> /home/ec2-user/.bashrc

# Ensure path
echo 'export PATH=$PATH:/usr/local/bin' >> /home/ec2-user/.bash_profile
chown ec2-user:ec2-user /home/ec2-user/.bash_profile
