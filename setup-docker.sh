#!/bin/bash
amazon-linux-extras install docker -y
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
systemctl enable docker
systemctl start docker
docker-compose -f /home/ec2-user/docker-compose.yml up -d
