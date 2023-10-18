#!/bin/sh

# This script is intended to be run using sudo
if [ 0 -ne `id -u` ]
then
    echo "This script must be run with elevated privleges"
    exit 1
fi

echo "Setting up Git defaults..."
git config --global user.email "brian.reich@thecoresolution.com"
git config --global user.name "Brian Reich"

if ! [ -x "$(command -v zsh)" ]; then
    echo "ZSH is not installed. Installing"
    pkg install -y zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if ! [ -x "$(command -v nvim)" ]; then
    echo "Neovim is not installed. Installing"
    pkg install -y neovim
fi

