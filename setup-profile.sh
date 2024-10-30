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

# Make sure tmux is setup, tmux plugin manager, and add our custom tmux
# configuration files

if ! [ -x "$(command -v tmux)" ]; then
    echo "tmux not found. Installing..."
    sudo apt install -y tmux
fi

echo "Setting up tmux plugin manager..."
tmuxPluginsPath="~/.tmux/plugins/tpm"
rm -fr $tmuxPluginPath
git clone https://github.com/tmux-plugins/tpm "$tmuxPluginPath" > /dev/null 2>&1

echo "Installing my tmux configuration..."
cp config/.tmux.conf ~

echo "tmux setup and configuration is complete."

# Get neovim setup

echo "Installing neovim..."

if ! [ -x "$(command -v nvim)" ]; then
    echo "Neovim is not installed. Installing"
    sudo apt install -y neovim > /dev/null 2>&1
fi

echo "Purging any existing neovim config..."
rm -fr ~/.config

echo "Copying baseline configuration..."
cp -fr ./config/.config ~/.config

echo "Instructing neovim to install all it's plugins..."
nvim +PlugInstall +qall

echo "Neovim setup and configuration is complete."

# Setup some other stuff that we might need.

if ! [ -x "$(command -v unzip)" ]; then
    echo "unzip not found. Installing"
    sudo apt install -y unzip > /dev/null 2>&1
fi

if ! [ -x "$(command -v wget)" ]; then
    echo "wget not found. Installing"
    sudo apt install -y wget > /dev/null 2>&1
fi

# Setting up ESlint and any plugins we want to have.

if ! [ -x "$(command -v node)" ]; then
    echo "Node is not installed. Installing..."
    sudo apt install -y nodejs > /dev/null 2>&1
fi

echo "Installing ESlint..."
npm install eslint --global > /dev/null 2>&1
sudo npm install eslint-plugin-html --global > /dev/null 2>&1

echo "ESLint installation and configuration is completed."

# Install starship, which is some fancy schmancy CLI toolbar stuff
# We also add starship to our zsh config, and set some presets
# for our color scheme
#
echo "Installing starship..."

if ! [ -x "$(command -v starship)" ]; then
    echo "starship not found. Installing..."

    # Install Starship
    curl -o ./install.sh https://starship.rs/install.sh
    chmod +x ./install.sh
    ./install.sh -f
    rm install.sh

    # Add line to init starship to .zshrc
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc
fi

echo "Initializing starship for zsh..."
starship init zsh  > /dev/null 2>&1

echo "Initializing starship presets..."
starship preset gruvbox-rainbow -o ~/.config/starship.toml > /dev/null 2>&1

echo "Starship setup and configuration is complete."

echo "Settings up PHPCS..."
composer global require "squizlabs/php_codesniffer=*" --dev > /dev/null 2>&1

echo "Installing vimeo/psalm globally..."
composer global require --dev vimeo/psalm > /dev/null 2>&1

echo "Copying git configuration file..."
cp config/.gitconfig ~

echo "Ubuntu environment setup complete. Have fun!"

