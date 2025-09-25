#!/bin/bash

echo "install and start apache"

sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd

echo "install and start docker"

yum install -y docker
systemctl enable docker
systemctl start docker

ehco "allow ec2-user to run docker"
usermod -aG docker ec2-user || true

# 커널 파라미터는 계속 추가해보기

echo "writing standard kernel params"

sudo bash -c 'cat > /etc/sysctl.d/99-standard.conf <<EOF
net.ipv4.tcp_max_syn_backlog = 65536
net.core.somaxconn = 16384
kernel.threads-max = 126000
net.ipv4.ip_local_port_range = 12768 65535
EOF'

echo "applying sysctl settings"

sudo sysctl --system
