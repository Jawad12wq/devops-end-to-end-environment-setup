#!/bin/bash

echo "📦 Installing Grafana..."

# Add Grafana APT repo
sudo apt-get install -y software-properties-common wget apt-transport-https
wget -q -O - https://packages.grafana.com/gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/grafana.gpg
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

# Update and install
sudo apt-get update
sudo apt-get install -y grafana

# Start and enable Grafana
sudo systemctl daemon-reexec
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

echo "✅ Grafana installed and running!"
echo "📍 Access it at: http://<VM3-IP>:3000"
echo "🔑 Default credentials: admin / admin"
