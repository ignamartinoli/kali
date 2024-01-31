#!/bin/sh

# NOTE: setaf 2 is green, setaf 3 is yellow

tput setaf 4; echo '-=-=-=-=-=[ Changing passwords ]=-=-=-=-=-'; tput sgr0
echo 'New password: \c'
read -r password
echo "root:$password" | sudo chpasswd
echo "kali:$password" | sudo chpasswd

tput setaf 4; echo '-=-=-=-=-=[ Updating ]=-=-=-=-=-'; tput sgr0
sudo apt update -qqy && sudo apt upgrade -qqy
sudo apt autoremove -qqy

tput setaf 4; echo '-=-=-=-=-=[ Upgrading ]=-=-=-=-=-'; tput sgr0
sudo apt update -qqy && sudo apt dist-upgrade -qqy

tput setaf 4; echo '-=-=-=-=-=[ Installing drivers ]=-=-=-=-=-'; tput sgr0
sudo apt install realtek-rtl88xxau-dkms -qqy

tput setaf 4; echo '-=-=-=-=-=[ Adding keymaps ]=-=-=-=-=-'; tput sgr0
sed -i '/backward-kill-line/a bindkey '\''^?'\'' backward-kill-word                   # ctrl + delete' "$HOME/.zshrc"
echo 'keycode 66 = Escape' > "$HOME/.Xmodmap"
xmodmap "$HOME/.Xmodmap"

tput setaf 4; echo '-=-=-=-=-=[ Installing Nerd Font ]=-=-=-=-=-'; tput sgr0
directory="$(mktemp -d)" # TODO: move to signal handled
fonts="$HOME/.local/share/fonts"
wget -qO "$directory/FiraCode.zip" 'github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip'
mkdir -p "$fonts" && unzip -od "$fonts" "$directory/FiraCode.zip"
fc-cache -fv

tput setaf 4; echo '-=-=-=-=-=[ Installing Neovim ]=-=-=-=-=-'; tput sgr0
wget -qO "$directory/nvim-linux64.tar.gz" 'github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz'
tar xzf "$directory/nvim-linux64.tar.gz" -C "$HOME"
ln -s "$HOME/nvim-linux64/bin/nvim" '/usr/local/bin/nvim'

rm -rf "$directory"

sudo apt install npm ripgrep -qqy
# git clone 'https://github.com/NvChad/NvChad' "$HOME/.config/nvim" --depth 1
# TODO: sed "$HOME/.config/nvim/lua/custom/configs/overrides.lua"

tput setaf 4; echo '-=-=-=-=-=[ SETUP FINISHED ]=-=-=-=-=-'; tput sgr0
