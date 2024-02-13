#!/bin/sh

echo "Setting up Git defaults..."
git config --global user.email "brian.reich@thecoresolution.com"
git config --global user.name "Brian Reich"
git config pull.rebase false
git config --global --add --bool push.autoSetupRemote true

if ! [ -x "$(command -v zsh)" ]; then
    echo "ZSH is not installed. Installing"
    sudo pkg install -y zsh
fi

echo "Setting up ZSH Syntax Highlighting..."
sudo pkg install -y zsh-syntax-highlighting

echo "Copying Zshell config..."
cp config/.zshrc ~

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Loading ZSH config..."
source ~/.zshrc

if ! [ -x "$(command -v tmux)" ]; then
    echo "tmux not found. Installing..."
    sudo pkg install -y tmux
fi

echo "Setting up tmux plugin manager..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Installing my tmux configuration..."
cp config/.tmux.conf ~

if ! [ -x "$(command -v nvim)" ]; then
    echo "Neovim is not installed. Installing"
    sudo pkg install -y neovim
fi

if ! [ -x "$(command -v unzip)" ]; then
    echo "unzip not found. Installing"
    pkg install -y unzip 
fi

if ! [ -x "$(command -v wget)" ]; then
    echo "wget not found. Installing"
    pkg install -y wget
fi

if ! [ -x "$(command -v starship)" ]; then
    echo "starship not found. Installing"

    # Install Starship
    pkg install -y starship

    # Install gruvbox-rainbow presets
    starship preset gruvbox-rainbow -o ~/.config/starship.toml

    # Add line to init starship to .zshrc
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc

    # Init starship
    starship init zsh
fi

echo "Setting up default Neovim config..."
rm -fr ~/.config
cp -fr config/.config ~/.config

echo "Settings up PHPCS..."
composer global require "squizlabs/php_codesniffer=*" --dev

echo "Installing vimeo/psalm globally..."
composer global require --dev vimeo/psalm
