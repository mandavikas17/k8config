#!/bin/bash
set -xe

# Update all packages
yum update -y

# Install dependencies
yum install -y git curl wget conntrack

# Enable and install Docker
amazon-linux-extras enable docker
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Install kubectl (latest stable version)
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# Install Minikube (latest version)
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
mv minikube /usr/local/bin/

# Fix PATH and permissions for ec2-user
echo 'export PATH=$PATH:/usr/local/bin' >> /home/ec2-user/.bash_profile
chown ec2-user:ec2-user /home/ec2-user/.bash_profile

# Start Minikube on first login (not in cloud-init, safer)
echo 'if ! minikube status &>/dev/null; then minikube start --driver=none; fi' >> /home/ec2-user/.bashrc
