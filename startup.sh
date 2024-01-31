#!/bin/sh

# NOTE: setaf 2 is green, setaf 3 is yellow

tput setaf 2; echo '-=-=-=-=-=[ Changing passwords ]=-=-=-=-=-'; tput sgr0
echo 'New password: \c'
read -r password
echo "root:$password" | sudo chpasswd
echo "kali:$password" | sudo chpasswd

tput setaf 2; echo '-=-=-=-=-=[ Updating ]=-=-=-=-=-'; tput sgr0
sudo apt update -qqy && sudo apt upgrade -qqy
sudo apt autoremove -qqy

tput setaf 2; echo '-=-=-=-=-=[ Upgrading ]=-=-=-=-=-'; tput sgr0
sudo apt update -qqy && sudo apt dist-upgrade -qqy

tput setaf 2; echo '-=-=-=-=-=[ Installing drivers ]=-=-=-=-=-'; tput sgr0
sudo apt install realtek-rtl88xxau-dkms -qqy

tput setaf 2; echo '-=-=-=-=-=[ Adding keymaps ]=-=-=-=-=-'; tput sgr0
sed -i '/backward-kill-line/a bindkey '\''^?'\'' backward-kill-word                   # ctrl + delete' "$HOME/.zshrc"
echo 'keycode 66 = Escape' > "$HOME/.Xmodmap"
xmodmap "$HOME/.Xmodmap"

tput setaf 2; echo '-=-=-=-=-=[ Installing Nerd Font ]=-=-=-=-=-'; tput sgr0
# TODO: directory="$(mktemp -d)"
fonts="$HOME/.local/share/fonts"
wget -qO "$HOME/FiraCode.zip" 'github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip'
mkdir -p "$fonts" && unzip -od "$fonts" "$HOME/FiraCode.zip" # BUG: cleanup before
fc-cache -fv

tput setaf 2; echo '-=-=-=-=-=[ Installing Neovim ]=-=-=-=-=-'; tput sgr0
wget -qO "$HOME/nvim-linux64.tar.gz" 'github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz'
tar xzf "$HOME/nvim-linux64.tar.gz" -C "$HOME" # BUG: cleanup
ln -s "$HOME/nvim-linux64/bin/nvim" '/usr/local/bin/nvim' # BUG: cleanup if already exists

sudo apt install npm ripgrep -qqy
# git clone 'https://github.com/NvChad/NvChad' "$HOME/.config/nvim" --depth 1
# TODO: sed "$HOME/.config/nvim/lua/custom/configs/overrides.lua"

tput setaf 2; echo '-=-=-=-=-=[ Setup finished ]=-=-=-=-=-'; tput sgr0
