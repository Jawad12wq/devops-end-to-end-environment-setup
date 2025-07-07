#!/bin/bash

# Define Prometheus version
PROM_VERSION="2.52.0"
PROM_FOLDER="prometheus-${PROM_VERSION}.linux-amd64"

echo "📦 Creating Prometheus user and directories..."
sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir -p /etc/prometheus /var/lib/prometheus

echo "📥 Downloading Prometheus..."
wget https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/${PROM_FOLDER}.tar.gz

echo "📦 Extracting..."
tar xvf ${PROM_FOLDER}.tar.gz

echo "📁 Installing Prometheus binaries..."
cd ${PROM_FOLDER}
sudo cp prometheus promtool /usr/local/bin/
sudo cp -r consoles console_libraries /etc/prometheus/
cd ..
rm -rf ${PROM_FOLDER}*

echo "⚙️ Creating Prometheus configuration..."
sudo tee /etc/prometheus/prometheus.yml > /dev/null <<EOF
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'vm1-node'
    static_configs:
      - targets: ['192.168.56.101:9100']

  - job_name: 'vm2-node'
    static_configs:
      - targets: ['192.168.56.102:9100']

  - job_name: 'nginx-exporter'
    static_configs:
      - targets: ['192.168.56.102:9113']
EOF

echo "⚙️ Creating Prometheus systemd service..."
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus Monitoring
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
ExecStart=/usr/local/bin/prometheus \\
  --config.file=/etc/prometheus/prometheus.yml \\
  --storage.tsdb.path=/var/lib/prometheus \\
  --web.console.templates=/etc/prometheus/consoles \\
  --web.console.libraries=/etc/prometheus/console_libraries

Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "📂 Setting permissions..."
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus

echo "🚀 Starting Prometheus..."
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

echo "✅ Prometheus installation and configuration complete!"
echo "📍 Visit: http://<VM3-IP>:9090 to verify"
