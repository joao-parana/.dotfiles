#!/bin/bash

set -euo pipefail

CRT_DIR=$(pwd)

cleanup() {
   cd "$CRT_DIR" 
}

trap 'cleanup' EXIT

EMAIL=${1-'dmarques2@gmail.com'}
SERVICE_NAME=${1-github}

ssh-keygen -t ed25519 -C "$EMAIL" -f "$HOME"/.ssh/"$USER"-"$SERVICE_NAME"_key

echo -e "KEY CREATED DO NOT FORGET TO UPLOAD THE PUBLIC PART!!!"
