#!/bin/bash

set -e

echo "[1] Updating package manager repositories..."
sudo apt-get update -y

echo "[2] Installing dependencies..."
sudo apt-get install -y ca-certificates curl gnupg

echo "[3] Creating directory for Docker GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings

echo "[4] Downloading Docker GPG key..."
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

echo "[5] Setting permissions for Docker GPG key..."
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "[6] Adding Docker repository to APT sources..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[7] Updating package manager again..."
sudo apt-get update -y

echo "[8] Installing Docker components..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "✅ Docker installation complete!"
