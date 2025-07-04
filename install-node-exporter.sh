#!/bin/bash

echo "🔧 Creating user for node_exporter..."
sudo useradd --no-create-home --shell /bin/false node_exporter

echo "⬇️ Downloading node_exporter..."
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz

echo "📦 Extracting node_exporter..."
tar xvf node_exporter-1.7.0.linux-amd64.tar.gz

echo "📂 Moving binary to /usr/local/bin..."
sudo cp node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

echo "📝 Creating systemd service..."
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

echo "🔁 Reloading and enabling node_exporter service..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

echo "✅ Node Exporter is now running on port 9100"
