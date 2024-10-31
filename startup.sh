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
 	sudo rm -f '/usr/local/bin/hx'
  	rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}/helix"
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
# sudo adduser "$username"
# sudo usermod -aG sudo "$username"
# sudo usermod -L kali

message 'Installing Guest Additions'
sudo mount '/dev/cdrom' '/media/kali'
sudo '/media/cdrom/VBoxLinuxAdditions.run'

message 'Updating'
export DEBIAN_FRONTEND='noninteractive'
sudo apt update -qqy && sudo apt upgrade -qqy
sudo apt autoremove -qqy

message 'Upgrading'
sudo apt update -qqy && sudo apt dist-upgrade -qqy

message 'Installing kernel headers'
sudo apt install "linux-headers-$(uname -r)"

message 'Installing drivers'
sudo apt install realtek-rtl88xxau-dkms -qqy

message 'Adding keymaps'
grep -q '^bindkey '\''^?'\''' "$HOME/.zshrc" || sed -i '/backward-kill-line/a bindkey '\''^?'\'' backward-kill-word                   # ctrl + delete' "$HOME/.zshrc"
echo 'keycode 66 = Escape' > "$HOME/.Xmodmap"
xmodmap "$HOME/.Xmodmap"

message 'Creating build directory'
playground="$(mktemp -d)"

message 'Installing Nerd Font'
fonts="$HOME/.local/share/fonts"
wget -qO "$playground/FiraCode.zip" 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip'
mkdir -p "$fonts" && unzip -od "$fonts" "$playground/FiraCode.zip"
fc-cache -fv

message 'Installing Helix'
version='24.07-x86_64-linux'
wget -qO "$playground/helix.tar.xz" "https://github.com/helix-editor/helix/releases/latest/download/helix-$version.tar.xz" 
tar -xf "$playground/helix.tar.xz" -C "$playground"
sudo mv "$playground/helix-$version/hx" '/usr/local/bin'
mv -f "$playground/helix-$version/runtime" "${XDG_CONFIG_HOME:-$HOME/.config}/helix"
wget -qO "${XDG_CONFIG_HOME:-$HOME/.config}/helix/config.toml" 'https://raw.githubusercontent.com/ignamartinoli/kali/master/config.toml'

message 'Setting wallpaper'
xfconf-query -c 'xfce4-desktop' -p '/backdrop/screen0/monitorVirtual1/workspace0/last-image' -s '/usr/share/backgrounds/kali-16x9/kali-metal-dark.png'

tput setaf 2; echo '-=-=-=-=-=[ Setup finished ]=-=-=-=-=-'; tput sgr0
tidy
