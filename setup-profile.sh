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

if ! [ "$(sudo pkg check -B ripgrep)" ]; then
    echo "Installing ripgrep"
    sudo pkg install -y ripgrep
fi

if ! [ -x "$(command -v luarocks)" ]; then
    echo "Installing Luarocks package manager"

    # Download
    wget -O luarocks.tar.gz https://luarocks.github.io/luarocks/releases/luarocks-3.9.2.tar.gz
    
    # Extract
    tar -xvzf luarocks.tar.gz
    
    # Do the build dance
    cd luarocks-3.9.2
    ./configure
    make
    sudo make install
    cd ..

    # Cleanup
    rm -fr luarocks*
fi

echo "Installing jsregexp Lua dependency required by snippets extension..."
sudo luarocks install jsregexp

if ! [ -x "$(command -v unzip)" ]; then
    echo "unzip not found. Installing"
    sudo pkg install -y unzip 
fi

if ! [ -x "$(command -v wget)" ]; then
    echo "wget not found. Installing"
    sudo pkg install -y wget
fi

echo "Setting up default Neovim config..."
rm -fr ~/.config 
cp -fr config/.config ~/.config

echo "Settings up PHPCS..."
composer global require "squizlabs/php_codesniffer=*" --dev

echo "Installing vimeo/psalm globally..."
composer global require --dev vimeo/psalm
