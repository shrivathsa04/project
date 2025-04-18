#!/bin/bash

# Define master node hostname
MASTER_NODE_NAME="master-node"  # <-- Replace this with your actual master hostname

echo "[1] Updating System Packages..."
sudo apt-get update -y

echo "[2] Installing Docker..."
sudo apt install docker.io -y
sudo chmod 666 /var/run/docker.sock

echo "[3] Installing Required Dependencies for Kubernetes..."
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
sudo mkdir -p -m 755 /etc/apt/keyrings

echo "[4] Adding Kubernetes Repository and GPG Key..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | \
sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | \
sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "[5] Updating Package List..."
sudo apt update -y

echo "[6] Installing Kubernetes Components (kubeadm, kubelet, kubectl)..."
sudo apt install -y kubeadm=1.28.1-1.1 kubelet=1.28.1-1.1 kubectl=1.28.1-1.1
sudo apt-mark hold kubelet kubeadm kubectl

echo "[7] Initializing Kubernetes Master Node..."
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

echo "[8] Configuring Kubernetes Cluster (kubectl)..."
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "[9] Deploying Calico Networking Solution..."
kubectl apply -f https://docs.projectcalico.org/v3.20/manifests/calico.yaml

echo "[10] Deploying Ingress Controller (NGINX)..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.49.0/deploy/static/provider/baremetal/deploy.yaml

echo "[11] Installing kubeaudit for Cluster Security Scanning..."
wget https://github.com/Shopify/kubeaudit/releases/latest/download/kubeaudit_0.22.0_linux_amd64.tar.gz
tar -xvf kubeaudit_0.22.0_linux_amd64.tar.gz
sudo mv kubeaudit /usr/local/bin/
kubeaudit all

