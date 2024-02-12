#!/bin/sh

tidy() {
	# BUG: if there is a problem with a package, dpkg fucks all the process up
	# sudo dpkg --configure -a
	rm -f "$HOME/.Xmodmap"
	rm -rf "$HOME/FiraCode.zip"
	rm -f "$HOME/nvim-linux64.tar.gz"
}

reset() {
	tidy
	rm -rf "$HOME/nvim-linux64"
 	rm -rf "$HOME/.config/nvim"
	rm -rf "$HOME/.local/share/nvim"
	rm -rf "$HOME/.local/state/nvim"
	rm -rf "$HOME/.cache/nvim"
	sudo rm -f '/usr/local/bin/nvim'
}

error() {
	tput setaf 1; echo '-=-=-=-=-=[ Error ]=-=-=-=-=-'; tput sgr0
	reset
	exit 1
}

sudo -v || { echo 'Incorrect password.'; exit 1; }
trap error 1 2 3 6
reset

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
grep -q '^bindkey '\''^?'\''' "$HOME/.zshrc" || sed -i '/backward-kill-line/a bindkey '\''^?'\'' backward-kill-word                   # ctrl + delete' "$HOME/.zshrc"
echo 'keycode 66 = Escape' > "$HOME/.Xmodmap"
xmodmap "$HOME/.Xmodmap"

tput setaf 2; echo '-=-=-=-=-=[ Installing Nerd Font ]=-=-=-=-=-'; tput sgr0
# TODO: directory="$(mktemp -d)"
fonts="$HOME/.local/share/fonts"
wget -qO "$HOME/FiraCode.zip" 'github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip'
mkdir -p "$fonts" && unzip -od "$fonts" "$HOME/FiraCode.zip"
fc-cache -fv

tput setaf 2; echo '-=-=-=-=-=[ Installing Neovim ]=-=-=-=-=-'; tput sgr0
wget -qO "$HOME/nvim-linux64.tar.gz" 'github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz'
tar xzf "$HOME/nvim-linux64.tar.gz" -C "$HOME"
sudo ln -s "$HOME/nvim-linux64/bin/nvim" '/usr/local/bin/nvim'

sudo apt install npm ripgrep -qqy
git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
rm -rf "$HOME/.config/nvim/.git"
# TODO: sed "$HOME/.config/nvim/lua/custom/configs/overrides.lua"

tput setaf 2; echo '-=-=-=-=-=[ Setup finished ]=-=-=-=-=-'; tput sgr0
tidy
