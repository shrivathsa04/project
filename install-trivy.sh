#!/bin/bash

set -e

echo "[1] Installing required dependencies..."
sudo apt-get install -y wget apt-transport-https gnupg lsb-release

echo "[2] Adding Trivy GPG key..."
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | \
sudo tee /usr/share/keyrings/trivy.gpg > /dev/null

echo "[3] Adding Trivy repository to sources list..."
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] \
https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | \
sudo tee /etc/apt/sources.list.d/trivy.list > /dev/null

echo "[4] Updating repositories..."
sudo apt-get update -y

echo "[5] Installing Trivy..."
sudo apt-get install -y trivy

echo "✅ Trivy installation complete!"
