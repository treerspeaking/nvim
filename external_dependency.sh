#!/bin/bash

function installGhDash(){
    gh extension install dlvhdr/gh-dash 
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    brew install gh
elif [[ -f /etc/arch-release ]]; then
    # Arch Linux / CachyOS
    sudo pacman -S --needed github-cli
elif [[ -f /etc/debian_version ]]; then
    # Ubuntu / Debian
    sudo apt-get update
    sudo apt-get install -y gh
fi

installGhDash


