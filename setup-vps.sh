# 1. Install docker

for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

sudo apt-get update
sudo apt-get install ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker root # TODO: USER'a wyciągnąć do zmiennej

# 2.1. Login to docker hub

docker login -u armatysme # TODO: Użytkownika dockerhub można wyciągnąć do zmiennej

# ?. Install RSYNC to sync files from GITHUB to VPS
apt-get install rsync

# 3. Prepare folder for application

mkdir -p /var/opeenet/ # TODO: Nazwa aplikacji do zmiennej
mkdir -p /var/common/vps/ 
mkdir -p /var/common/app/ 

# 3.1 Add docker network
docker network create vps-network

# 4. Copy docker-composes files to proper folders

cp DOCKER/.env /var/common/app/.env
cp DOCKER/.env /var/common/vps/.env

cp DOCKER/docker-compose.mssql.yml /var/common/app/docker-compose.mssql.yml
cp DOCKER/docker-compose.rabbit.yml /var/common/app/docker-compose.rabbit.yml
cp DOCKER/docker-compose.seq.yml /var/common/app/docker-compose.seq.yml
cp DOCKER/docker-compose.webhook.yml /var/common/app/docker-compose.webhook.yml

cp DOCKER/docker-compose.nginx.yml /var/common/vps/docker-compose.nginx.yml
cp DOCKER/docker-compose.portainer.yml /var/common/vps/docker-compose.portainer.yml

# ?. Generate keys to authorize with Github Actions

ssh-keygen -m PEM -t rsa -b 4096
cat id_rsa.pub >> ~/.ssh/authorized_keys

# ?. Add permissions to folders

sudo chmod 777 /var/opeenet/ # TODO: Nazwa aplikacji do zmiennej
sudo chmod -R 777 /var/common/

# ?. Run all needed containers

cd /var/common/app/
sudo docker compose -f docker-compose.rabbit.yml up -d
sudo docker compose -f docker-compose.mssql.yml up -d
sudo docker compose -f docker-compose.seq.yml up -d
sudo docker compose -f docker-compose.webhook.yml up -d

cd /var/common/vps/
sudo docker compose -f docker-compose.nginx.yml up -d
sudo docker compose -f docker-compose.portainer.yml up -d

# -----

# Prepare .env file for app and commons

# Choose app to run on docker from docker composes

# Create user for make.com to trigger update (or create new weebook by call API from make.com | for update app & database)

# Konfigruacja bezpieczeństwa VPS'a
# a) Fail2Ban