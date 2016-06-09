#!/bin/bash


# docker install
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-wily main" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get purge lxc-docker
sudo apt-get install -y linux-image-extra-$(uname -r)
sudo apt-get install -y docker-engine

echo -e "..............\n\n\nNow installing docker compose\n\n\n.............."
# docker compose install
curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null
sudo chmod +x /usr/local/bin/docker-compose

echo -e "..............\n\n\nNow Installing pip & aws cli\n\n\n.............."
sudo apt-get install -y python-pip python-dev
sudo pip install awscli

echo -e "..............\n\n\nNow updating system configs\n\n\n.............."
# system configs
sudo usermod -aG docker ubuntu
sudo mkdir /etc/systemd/system/docker.service.d
echo "Restart:on-failure" | sudo tee /etc/systemd/system/docker.service.d/override.conf > /dev/null
echo "[Service]
LimitMEMLOCK=infinity" | sudo tee /etc/systemd/system/docker.service.d/increase-ulimit.conf > /dev/null
sudo systemctl daemon-reload
sudo systemctl restart docker

echo -e "..............\n\n\nNow Updating fs\n\n\n.............."
# filesystem requirements
sudo mkdir /data || :
sudo chown -R ubuntu:docker /data
