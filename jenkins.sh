#!/bin/bash

echo "[1] Installing OpenJDK 17 JRE Headless..."
sudo apt install openjdk-17-jre-headless -y

echo "[2] Downloading Jenkins GPG key..."
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "[3] Adding Jenkins repository..."
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

echo "[4] Updating package manager..."
sudo apt-get update -y

echo "[5] Installing Jenkins..."
sudo apt-get install jenkins -y

echo "✅ Jenkins installation complete. You can start Jenkins using:"
echo "   sudo systemctl start jenkins"
echo "   sudo systemctl enable jenkins"
