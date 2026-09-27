#!/bin/bash

function installGhDash() {
    gh extension install dlvhdr/gh-dash
}

# Global C/C++ format style (clang-format searches up to ~ when a project has none)
function linkClangFormat() {
    if [[ ! -e "$HOME/.clang-format" ]]; then
        ln -s "$HOME/.config/nvim/lang_config/cpp/.clang-format" "$HOME/.clang-format"
    fi
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    brew install gh pngpaste imagemagick
elif [[ -f /etc/arch-release ]]; then
    # Arch Linux / CachyOS
    sudo pacman -S --needed github-cli
elif [[ -f /etc/debian_version ]]; then
    # Ubuntu / Debian
    sudo apt-get update
    sudo apt-get install -y gh
fi

installGhDash
linkClangFormat
