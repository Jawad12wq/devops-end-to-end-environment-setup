#!/bin/bash

# Set version and variables
EXPORTER_VERSION="1.1.0"
EXPORTER_TAR="nginx-prometheus-exporter_${EXPORTER_VERSION}_linux_amd64.tar.gz"
EXPORTER_DIR="nginx-prometheus-exporter_${EXPORTER_VERSION}_linux_amd64"
NGINX_STATUS_PORT=8080

echo -e "\n* Downloading NGINX Prometheus Exporter . . ."
wget -q https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v${EXPORTER_VERSION}/${EXPORTER_TAR}

echo -e "\n* Extracting exporter . . ."
mkdir -p $EXPORTER_DIR
tar -xzf $EXPORTER_TAR -C $EXPORTER_DIR

echo -e "\n* Installing exporter . . ."
sudo cp $EXPORTER_DIR/nginx-prometheus-exporter /usr/local/bin/
sudo chmod +x /usr/local/bin/nginx-prometheus-exporter

echo -e "\n* Configuring NGINX status endpoint . . ."
sudo tee /etc/nginx/conf.d/status.conf > /dev/null <<EOF
server {
    listen ${NGINX_STATUS_PORT};
    location /nginx_status {
        stub_status;
        allow 127.0.0.1;
        allow 192.168.56.103;  # Replace with Prometheus VM IP if needed
        deny all;
    }
}
EOF

echo -e "\n* Restarting NGINX . . ."
sudo nginx -t && sudo systemctl restart nginx

echo -e "\n* Creating nginx-exporter systemd service . . ."
sudo tee /etc/systemd/system/nginx-exporter.service > /dev/null <<EOF
[Unit]
Description=NGINX Prometheus Exporter
After=network.target

[Service]
ExecStart=/usr/local/bin/nginx-prometheus-exporter \\
  -nginx.scrape-uri http://localhost:${NGINX_STATUS_PORT}/nginx_status
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo -e "\n* Starting NGINX Prometheus Exporter . . ."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable nginx-exporter
sudo systemctl start nginx-exporter

echo -e "\n✅ NGINX Prometheus Exporter installed and running!"
