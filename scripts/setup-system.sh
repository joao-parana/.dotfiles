#!/bin/bash

set -euo pipefail

CRT_DIR=$(pwd)

cleanup() {
   cd "$CRT_DIR" 
}

trap 'cleanup' EXIT

cd "${0%/*}"/..

EMAIL=${1-'dmarques2@gmail.com'}

echo "Installing applications from pacman..."

sudo scripts/install-apps.sh

echo "Installing applications from AUR..."

scripts/install-aur.sh

echo "Creating directory structure..."

scripts/make-dirs.sh

echo "Stowing configurations..."

cd stow

stow -vt ~ *

cd ..

echo "Installing VSCode extentions..."

scripts/install-extensions.sh

echo "SSH configuration..."

< ssh-config/config sed "s/{user}/$USER/g" > ~/.ssh/config

scripts/create-ssh-keys.sh "$EMAIL" github

scripts/create-ssh-keys.sh "$EMAIL" gitlab

scripts/create-ssh-keys.sh "$EMAIL" bitbucket

read -n1 -s -r -p $'Upload public keys to GitHub/Lab!\nPress ANY key to continue...\n' key

echo "Switching repository remote to a SSH based address..."

scripts/fix-remote.sh

echo -e "Config done! Test github connection with 'ssh -T git@github.com'.\nAnd to setup SOMA type 'scripts/create-soma-workspace.sh'"
