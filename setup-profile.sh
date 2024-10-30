#!/bin/sh

# Setup git default such as email address, name, merge/rebase strategy, and
# auto push options.

echo "Setting up Git defaults..."
git config --global user.email "brian.reich@thecoresolution.com"
git config --global user.name "Brian Reich"
git config pull.rebase false
git config --global --add --bool push.autoSetupRemote true

# Setup zsh, syntax highlighting, Oh My! zsh, and custom configuration.
# Make zsh the default shell.

if ! [ -x "$(command -v zsh)" ]; then
    echo "ZSH is not installed. Installing"
    sudo apt install -y zsh > /dev/null 2>&1
fi

echo "Setting up zsh Syntax Highlighting..."
sudo apt install -y zsh-syntax-highlighting > /dev/null 2>&1

echo "Making zsh the default shell"
chsh $(which zsh)

echo "Installing Oh My! Zshell..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null 2>&1

echo "Copying zsh config..."
cp ./config/.zshrc ~/.zshrc

echo "zsh setup complete. The next time you login, zsh will be your default shell."

# Make sure tmux is setup.

if ! [ -x "$(command -v tmux)" ]; then
    echo "tmux not found. Installing..."
    sudo apt install -y tmux
fi

echo "Setting up tmux plugin manager..."
tmuxPluginsPath="~/.tmux/plugins/tpm"
rm -fr $tmuxPluginPath
git clone https://github.com/tmux-plugins/tpm "$tmuxPluginPath"

exit 1
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

echo "Installing ESLint..."
npm install eslint --global
sudo npm install eslint-plugin-html --global

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

echo "Copying git configuration file..."
cp config/.gitconfig ~
