#!/bin/bash

pacman -Syu --needed - < pkg.list

paru -Syu --needed - < aur.list

groupadd docker

usermod -aG docker $USER

echo "127.0.0.1 desktop.cepel.br" >> /etc/hosts
echo "127.0.0.1 $hostname.cepel.br" >> /etc/hosts

#add 

echo "listen_addresses = '*'" >> /var/lib/posgres/data/postgres.conf
echo "host all all 172.17. 0.0/16 trust" >> /var/lib/postgres/data/pg_hba.conf


mkdir -p ~/.docker-volulmes/pgAdmin
mkdir -p ~/.docker-volulmes/postgresql

chattr +C ~/.docker-volulmes/postgresql


sudo chown -R 5050:5050 ~/.docker-volulmes/pgAdmin


docker pull dpage/pgadmin4
