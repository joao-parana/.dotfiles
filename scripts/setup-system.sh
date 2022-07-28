#!/bin/bash

set -euo pipefail

CRT_DIR=$(pwd)

cleanup() {
   cd "$CRT_DIR" 
}

trap 'cleanup' EXIT

cd "${0%/*}"/..

sudo scripts/install-apps.sh

scripts/install-aur.sh

scripts/make-dirs.sh

cd stow

stow -vt ~ *

cd ..

scripts/install-extensions.sh

scripts/create-ssh-keys.sh

read -n1 -s -r -p $'Upload public keys to GitHub/Lab!\nPress ANY key to continue...\n' key

ssh -T git@github.com

scripts/fix-remote.sh

echo "Config done! To setup SOMA type 'scripts/create-soma-workspace.sh'"

