#!/bin/bash
set -xe

sudo yum update -y

# Install git
sudo yum install git -y

# Install Docker on Amazon Linux 2
sudo yum install -y docker
sudo amazon-linux-extras enable docker
sudo systemctl start docker
sudo systemctl enable docker

# Add ec2-user to docker group
sudo usermod -aG docker ec2-user

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
sudo chown ec2-user:ec2-user /usr/local/bin/kubectl

# Install conntrack (required for minikube)
sudo yum install -y conntrack

# Install minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/
sudo chown ec2-user:ec2-user /usr/local/bin/minikube

# Add /usr/local/bin to ec2-user PATH if not present
if ! grep -q '/usr/local/bin' /home/ec2-user/.bash_profile; then
  echo 'export PATH=$PATH:/usr/local/bin' >> /home/ec2-user/.bash_profile
  sudo chown ec2-user:ec2-user /home/ec2-user/.bash_profile
fi

# Start minikube with none driver as ec2-user
sudo -i -u ec2-user bash << EOF
export PATH=\$PATH:/usr/local/bin
minikube start
EOF
