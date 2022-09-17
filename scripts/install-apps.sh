#!/bin/bash

set -euo pipefail

CRT_DIR=$(pwd)

cleanup() {
   cd "$CRT_DIR" 
}

trap 'cleanup' EXIT

cd "${0%/*}"/../packages

pacman -Sy --needed $(< pkg.list tr "\n" " ")

vagrant plugin install vagrant-libvirt

flatpak install flathub $(< flathub.list tr "\n" " ")

getent group docker || groupadd docker

usermod -aG docker "$USER"
usermod -aG libvirt "$USER"

echo "127.0.0.1 $HOSTNAME.cepel.br" >> /etc/hosts
echo " "
echo "# Local test server" >> /etc/hosts
echo "127.0.0.1 desktop.cepel.br" >> /etc/hosts
echo "127.0.0.1 health-desktop.cepel.br" >> /etc/hosts
echo " "
echo "# Debian VMs" >> /etc/hosts
echo "192.168.10.4 deb1.cepel.br" >> /etc/hosts
echo "192.168.10.4 health-deb1.cepel.br" >> /etc/hosts
echo "192.168.10.5 deb2.cepel.br" >> /etc/hosts
echo "192.168.10.5 health-deb2.cepel.br" >> /etc/hosts
echo "192.168.10.6 deb3.cepel.br" >> /etc/hosts
echo "192.168.10.6 health-deb3.cepel.br" >> /etc/hosts
echo " "
echo "# CentOS 8 VMs" >> /etc/hosts
echo "192.168.11.4 c8-1.cepel.br" >> /etc/hosts
echo "192.168.11.4 health-c8-1.cepel.br" >> /etc/hosts
echo "192.168.11.5 c8-2.cepel.br" >> /etc/hosts
echo "192.168.11.5 health-c8-2.cepel.br" >> /etc/hosts
echo "192.168.11.6 c8-3.cepel.br" >> /etc/hosts
echo "192.168.11.6 health-c8-3.cepel.br" >> /etc/hosts
echo " "
echo "# CentOS 7 VMs" >> /etc/hosts
echo "192.168.12.4 c7-1.cepel.br" >> /etc/hosts
echo "192.168.12.4 health-c7-1.cepel.br" >> /etc/hosts
echo "192.168.12.5 c7-2.cepel.br" >> /etc/hosts
echo "192.168.12.5 health-c7-2.cepel.br" >> /etc/hosts
echo "192.168.12.6 c7-3.cepel.br" >> /etc/hosts
echo "192.168.12.6 health-c7-3.cepel.br" >> /etc/hosts
