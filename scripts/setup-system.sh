#!/bin/bash

set -euo pipefail

CRT_DIR=$(pwd)

cleanup() {
   cd "$CRT_DIR" 
}

trap 'cleanup' EXIT

cd "${0%/*}"/..

EMAIL=${1-'dmarques2@gmail.com'}
SERVICE_NAME=${2-github}

sudo scripts/install-apps.sh

scripts/install-aur.sh

scripts/make-dirs.sh

cd stow

stow -vt ~ *

cd ..

scripts/install-extensions.sh

scripts/create-ssh-keys.sh "$EMAIL" "$SERVICE_NAME"

read -n1 -s -r -p $'Upload public keys to GitHub/Lab!\nPress ANY key to continue...\n' key

scripts/fix-remote.sh

echo "Config done! To setup SOMA type 'scripts/create-soma-workspace.sh'"

ssh -T git@github.com
