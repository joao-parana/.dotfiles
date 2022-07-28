#/bin/bash

set -euo pipefail

CRT_DIR=$(pwd)

cleanup() {
   cd "$CRT_DIR" 
}

trap 'cleanup' EXIT

mkdir ~/.ssh

mkdir -p ~/.config/kitty

mkdir -p ~/.config/"Code - OSS"/User

mkdir -p ~/.config/conky

mkdir -p ~/.local/share/applications/

rm ~/.config/starship.toml
rm ~/.config/fish/config.fish
rm ~/.config/autostart/conky.desktop
