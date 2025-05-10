#!/bin/sh

# Setup git default such as email address, name, merge/rebase strategy, and
# auto push options.

CONFIG_PATH=$(realpath "$(pwd)/config")
USER_HOME_DIRECTORY=$(eval echo ~$USER)

ERROR_CODE_VIM_DEFAULTS="Failed to install vim defaults"
ERROR_CODE_VIM_DEFAULT=1
ERROR_CODE_ZSH_INSTALL_FAILED=2
ERROR_MESSAGE_ZSH_INSTALL_FAILED="zsh install failed"
ERROR_MESSAGE_ZSH_HIGHLIGHTING_FAILED="Installing zsh syntax highlighting failed"
ERROR_CODE_ZSH_HIGHLIGHTING_FAILED=3
ERROR_MESSAGE_SET_SHELL_FAILED="Setting default shell to zsh failed"
ERROR_CODE_SET_SHELL_FAILED=4
ERROR_MESSAGE_OH_MY_ZSH_FAILED="Installing Oh My! Zshell failed"
ERROR_CODE_OH_MY_ZSH_FAILED=5
ERROR_MESSAGE_CONFIG_ZSH_FAILED="Configuring zsh failed"
ERROR_CODE_CONFIG_ZSH_FAILED=6

# Setup vim defaults by copying over the vim profile config to the
# right location in the current user's home directory.
echo "Setting up vim defaults..."
cp  "$CONFIG_PATH/.vimrc" "$USER_HOME_DIRECTORY/.vimrc"
if [ $? -ne 0 ]; then
    echo $ERROR_MESSAGE_VIM_DEFAULTS
    exit $ERROR_CODE_VIM_DEFAULT
fi

# Setup some opinionated Git defaults. This includes
# - My email address
# - My name
# - Use merge, not rebase, to merge differing changes together
# - Auto push to remote
echo "Setting up Git defaults..."
git config --global user.email "brian.reich@thecoresolution.com"
git config --global user.name "Brian Reich"
git config pull.rebase false
git config --global --add --bool push.autoSetupRemote true

# Install zsh (Zshell) if it is not already installed
if ! [ -x "$(command -v zsh)" ]; then
    echo "ZSH is not installed. Installing"
    sudo apt install -y zsh > /dev/null 2>&1
    if [ $? -ne 0 ]; then
		echo $ERROR_MESSAGE_ZSH_INSTALLED_FAILED
        exit $ERROR_CODE_ZSH_INSTALL_FAILED
	fi
fi

# Setup zsh syntax highlighting
echo "Setting up zsh Syntax Highlighting..."
sudo apt install -y zsh-syntax-highlighting > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo $ERROR_MESSAGE_ZSH_HIGHLIGHTING_FAILED
    exit $ERROR_CODE_ZSH_HIGHLIGHTING_FAILED
fi

# Set the user's default shell to zsh
echo "Making zsh the default shell"
chsh -s $(which zsh)
if [ $? -ne 0 ]; then
	echo $ERROR_MESSAGE_SET_SHELL_FAILED
    exit $ERROR_CODE_SET_SHELL_FAILED
fi

# Setting up Oh My! Zshell, an add-on pack to make
# zsh kick more butt.
echo "Installing Oh My! Zshell..."
rm -fr "$USER_HOME_DIRECTORY/.oh-my-zsh"
sh -c "ZSH= $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) > /dev/null 2>&1" 
if [ $? -ne 0 ]; then
    echo $ERROR_MESSAGE_OH_MY_ZSH_FAILED
    exit $ERROR_CODE_OH_MY_ZSH_FAILED
fi

# Configure ZSH defaults
echo "Copying zsh config..."
cp "$CONFIG_PATH/.zshrc" "$USER_HOME_DIRECTORY~/.zshrc"
if [ $? -ne 0 ]; then
    echo $ERROR_MESSAGE_CONFIG_ZSH_FAILED
    echo $ERROR_CODE_ZSH_FAILED
fi
echo "zsh setup complete. The next time you login, zsh will be your default shell."

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

