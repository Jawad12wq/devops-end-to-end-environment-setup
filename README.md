# devops-end-to-end-environment-setup
## 📁 Project Structure

```bash
.
├── terraform/                  # Terraform + Vagrant configs for VM provisioning
│   └── main.tf
│   └── variables.tf
│   └── Vagrantfile
├── ansible/                    # Ansible playbooks for configuration
│   └── inventory
│   └── apache_setup.yaml
│   └── github_project.yaml
│   └── nginx_https.yaml
├── monitoring/                 # Prometheus and Grafana configs
│   └── prometheus.yml
│   └── exporters/
│       └── node_exporter.service
│       └── nginx_exporter.service
├── scripts/                    # Shell scripts for automation
├── README.md
└── screenshots/
```
 1. VM Provisioning with Terraform + Vagrant
VM1: Apache Web Server → 192.168.56.101

VM2: GitHub Project + NGINX HTTPS Reverse Proxy → 192.168.56.102

VM3: Prometheus + Grafana Monitoring Stack → 192.168.56.103

Skills:
Infrastructure as Code (IaC)

Multi-VM environment setup

Static IP assignments

VirtualBox networking

⚙️ 2. Configuration with Ansible
VM1:

Installed Apache server

VM2:

Cloned personal GitHub portfolio repo

Served via Python HTTP server on port 8090

Installed and configured NGINX with HTTPS (self-signed SSL)

Used Ansible playbooks for package installation, service configuration, and deployment.

Skills:
Writing Ansible playbooks in YAML

Using apt, service, git, copy modules

Idempotent configuration management

🌐 3. NGINX HTTPS Reverse Proxy on VM2
NGINX listens on port 443

Reverse proxies traffic to Python HTTP server (port 8090)

Self-signed SSL certificate used

Site enabled and validated

Skills:
Configuring SSL with OpenSSL

Writing and enabling custom NGINX configs

Troubleshooting reverse proxy issues

📈 4. Monitoring Stack with Prometheus & Grafana
VM3 hosts both Prometheus and Grafana

Scrapes:

Node Exporter from VM1 and VM2

NGINX Exporter from VM2

Custom prometheus.yml for target discovery

Grafana dashboards imported:

1860 – Node Exporter metrics

12708 – NGINX metrics

Skills:
Installing Prometheus and exporters

Setting up systemd services

Importing Grafana dashboards
Screenshots 
VM1 DASHBOARD
![image](https://github.com/user-attachments/assets/3d48239f-86af-40fa-a5b3-56eb616c865f)
VM2 DASHBOARD
![image](https://github.com/user-attachments/assets/4bb241f2-e39c-42aa-82f9-139b8e43324a)
Nginx Dashboard
![image](https://github.com/user-attachments/assets/0e51165c-a835-45eb-b84c-c8d148e45703)


