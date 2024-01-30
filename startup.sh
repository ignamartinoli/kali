#!/bin/sh

# NOTE: setaf 2 is green, setaf 3 is yellow

[ "$(id -u)" -eq 0 ] || { tput setaf 1; echo "You must run this as root"; tput sgr0; exit 1; }

user="/home/$(id -un)"

tput setaf 4; echo '-=-=-=-=-=[ Changing passwords ]=-=-=-=-=-'; tput sgr0
echo 'New password: \c'
read -r password
echo "root:$password" | chpasswd
echo "kali:$password" | chpasswd

tput setaf 4; echo '-=-=-=-=-=[ Updating ]=-=-=-=-=-'; tput sgr0
apt update -qqy && apt upgrade -qqy
apt autoremove -qqy

tput setaf 4; echo '-=-=-=-=-=[ Upgrading ]=-=-=-=-=-'; tput sgr0
apt update -qqy && apt dist-upgrade -qqy

tput setaf 4; echo '-=-=-=-=-=[ Installing drivers ]=-=-=-=-=-'; tput sgr0
apt install realtek-rtl88xxau-dkms -qqy

tput setaf 4; echo '-=-=-=-=-=[ Adding keymaps ]=-=-=-=-=-'; tput sgr0
sed -i '/backward-kill-line/a bindkey '\''^?'\'' backward-kill-word                   # ctrl + delete' "$user/.zshrc"
echo 'keycode 66 = Escape' > "$user/.Xmodmap"
xmodmap "$user/.Xmodmap"

tput setaf 4; echo '-=-=-=-=-=[ Installing Nerd Font ]=-=-=-=-=-'; tput sgr0
fonts="$user/.local/share/fonts"
wget -qO "$user/FiraCode.zip" 'github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip'
[ -d "$fonts" ] || mkdir -p "$fonts" && unzip -od "$fonts" "$user/FiraCode.zip"
rm "$user/FiraCode.zip"
fc-cache -fv

tput setaf 4; echo '-=-=-=-=-=[ Installing Neovim ]=-=-=-=-=-'; tput sgr0
wget -qO "$user/nvim-linux64.tar.gz" 'github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz'
tar xzf "$user/nvim-linux64.tar.gz" -C "$user"
rm "$user/nvim-linux64.tar.gz"
ln -s "$user/nvim-linux64/bin/nvim" '/usr/local/bin/nvim'
apt install npm ripgrep -qqy
git clone 'https://github.com/NvChad/NvChad' "$user/.config/nvim" --depth 1
# TODO: sed "$HOME/.config/nvim/lua/custom/configs/overrides.lua"

tput setaf 4; echo '-=-=-=-=-=[ SETUP FINISHED ]=-=-=-=-=-'; tput sgr0
