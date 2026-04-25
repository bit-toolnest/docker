#!/bin/bash
set -e

echo "=== Docker + Registry Uninstaller Script ==="

# Remove registry container if it exists
if sudo docker ps -a --format '{{.Names}}' | grep -q '^registry$'; then
  echo "➡ Removing local Docker registry..."
  sudo docker stop registry || true
  sudo docker rm -f registry || true
  echo "✅ Registry container removed"
else
  echo "✅ No registry container found"
fi

# Uninstall Docker
if command -v docker >/dev/null 2>&1; then
  echo "➡ UnInstalling Docker..."
  sudo systemctl stop docker || true
  sudo systemctl disable docker || true
  sudo apt remove --purge docker.io -y || true

  # Remove Docker data directories
  sudo rm -rf /var/lib/docker /etc/docker || true

  echo "✅ Docker removed"
else
  echo "✅ Docker was not installed"
fi

# Cleanup
echo "➡ Running apt cleanup..."
sudo apt autoremove -y
sudo apt clean

echo "🎯 Docker + Registry uninstall process finished!"
