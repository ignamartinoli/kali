#!/bin/sh

# TODO: install pip?, rm gnome-software?, install golang?, install wallpapers?, install docker?, install zmap?, install hcxtools?, install bettercap?, install eaphammer?, install gowitness?, install man-spider?, install bloodhound?, install PCredz?, install EavesARP?, install CrackMapExec?, install Impacket?
# TODO: initializing metasploit database?
# TODO: unzipping RockYou
# TODO: BurpSuite Pro?
# TODO: Firefox Add-Ons?
# TODO: https://github.com/blacklanternsecurity/kali-setup-script/blob/master/kali-setup-script.sh

message() {
	tput setaf 2; echo "-=-=-=-=-=[ $1 ]=-=-=-=-=-"; tput sgr0
}

tidy() {
	# BUG: if there is a problem with a package, dpkg fucks all the process up
	# sudo dpkg --configure -a
	rm -rf "$HOME/FiraCode.zip" "$HOME/nvim-linux64.tar.gz"
}

reset() {
	tidy
 	rm -f "$HOME/.Xmodmap"
	rm -rf "$HOME/nvim-linux64" "$HOME/.config/nvim" "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"
	# sudo rm -f '/usr/local/bin/nvim'
 	sudo rm -f '/usr/local/bin/hx'
  	rm -r "$HOME/.config/helix"
}

error() {
	stty echo
	tput setaf 1; echo '-=-=-=-=-=[ Error ]=-=-=-=-=-'; tput sgr0
	reset
	exit 1
}

sudo -v || { echo 'Incorrect password.'; exit 1; }
trap error 1 2 3 6
reset

message 'Changing passwords'
echo 'New password: \c'
stty -echo
read -r password
stty echo
echo
echo "root:$password" | sudo chpasswd
echo "kali:$password" | sudo chpasswd

message 'Updating'
export DEBIAN_FRONTEND='noninteractive'
sudo apt update -qqy && sudo apt upgrade -qqy
sudo apt autoremove -qqy

message 'Upgrading'
tput setaf 2; echo '-=-=-=-=-=[ Upgrading ]=-=-=-=-=-'; tput sgr0
sudo apt update -qqy && sudo apt dist-upgrade -qqy

message 'Installing kernel headers'
sudo apt install "linux-headers-$(uname -r)"

message 'Installing drivers'
sudo apt install realtek-rtl88xxau-dkms -qqy

message 'Adding keymaps'
grep -q '^bindkey '\''^?'\''' "$HOME/.zshrc" || sed -i '/backward-kill-line/a bindkey '\''^?'\'' backward-kill-word                   # ctrl + delete' "$HOME/.zshrc"
echo 'keycode 66 = Escape' > "$HOME/.Xmodmap"
xmodmap "$HOME/.Xmodmap"

message 'Installing Nerd Font'
# TODO: directory="$(mktemp -d)"
fonts="$HOME/.local/share/fonts"
wget -qO "$HOME/FiraCode.zip" 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip'
mkdir -p "$fonts" && unzip -od "$fonts" "$HOME/FiraCode.zip"
fc-cache -fv

# message 'Installing Neovim'
# wget -qO "$HOME/nvim-linux64.tar.gz" 'https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz'
# tar xzf "$HOME/nvim-linux64.tar.gz" -C "$HOME"
# sudo ln -sfn "$HOME/nvim-linux64/bin/nvim" '/usr/local/bin/nvim'
version='24.07-x86_64-linux'
wget -q "https://github.com/helix-editor/helix/releases/latest/download/helix-$version.tar.xz" 
tar -xf "$HOME/helix-$version"
mv "$HOME/helix-$version/hx" "/usr/local/bin"
# mkdir "$XDG_CONFIG_HOME/helix"
mv "$HOME/helix-$version/runtime" "$XDG_CONFIG_HOME/helix/"
rm -r "$HOME/helix-$version"*

sudo apt install npm ripgrep -qqy
git clone 'https://github.com/LazyVim/starter' "$HOME/.config/nvim"
rm -rf "$HOME/.config/nvim/.git"
# TODO: sed "$HOME/.config/nvim/lua/custom/configs/overrides.lua"

message 'Setting wallpaper'
xfconf-query -c 'xfce4-desktop' -p '/backdrop/screen0/monitorVirtual1/workspace0/last-image' -s '/usr/share/backgrounds/kali-16x9/kali-metal-dark.png'

tput setaf 2; echo '-=-=-=-=-=[ Setup finished ]=-=-=-=-=-'; tput sgr0
tidy
