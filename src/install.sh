#!/bin/bash
set -e

echo "=== Install Script ==="

# 5) Install Docker only if not installed
if ! command -v docker >/dev/null 2>&1; then
  echo "➡ Installing Docker..."
  sudo apt update
  sudo apt install docker.io -y
  sudo systemctl enable docker
  sudo systemctl start docker
else
  echo "✅ Docker already installed"
fi

# 7) Setup local Docker registry (auto-restart on reboot)
echo "➡ Setting up local Docker registry..."

if sudo docker ps -a --format '{{.Names}}' | grep -q '^registry$'; then
    echo "✅ Registry container already exists"
    # Ensure it's running
    sudo docker start registry || true
else
    echo "➡ Creating registry container..."
    sudo docker run -d \
        -p 5000:5000 \
        --restart=always \
        --name registry \
        registry:2
    echo "✅ Local Docker registry started on port 5000"
fi

echo "🎯 Install script finished successfully!"

