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

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

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

echo "Setting up default Neovim config..."
git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
nvim --headless "+Lazy! sync" +qa

echo "Setting up Neovim plugin manager..."
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
