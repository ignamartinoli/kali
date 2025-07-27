#!/bin/sh

# TODO: add zellij when available
# TODO: add prompts
# TODO: fix Guest Additions
# TODO: evaluate PCredz
# TODO: evaluate EavesARP
# TODO: evaluate man-spider
# TODO: evaluate zmap

message() {
	tput setaf 2
	echo "-=-=-=-=-=[ $1 ]=-=-=-=-=-"
	tput sgr0
}

reset() {
	rm -f "$HOME/.Xmodmap"
	sudo rm -f '/usr/local/bin/hx'
	rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}/helix"
}

error() {
	stty echo
	tput setaf 1
	echo '-=-=-=-=-=[ Error ]=-=-=-=-=-'
	tput sgr0
	reset
	exit 1
}

sudo -v || {
	echo 'Incorrect password.'
	exit 1
}
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
sudo /media/kali/*/VBoxLinuxAdditions.run

export DEBIAN_FRONTEND='noninteractive'

message 'Installing kernel headers'
sudo apt install "linux-headers-$(uname -r)" -qqy

message 'Updating'
sudo apt update -qqy
sudo apt upgrade -qqy
sudo apt autoremove -qqy
sudo apt dist-upgrade -qqy

message 'Installing drivers'
sudo apt install 'realtek-rtl88xxau-dkms' -qqy

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

message 'Installing editor'
while true; do
	printf "1) Neovim\n2) Helix\n\nSelect: "
	read -r choice

	case "$choice" in
		1)
			sudo apt install 'neovim' -qqy
			git clone 'https://github.com/LazyVim/starter' "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
			rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/.git"
			sudo apt install 'npm' -qqy
			;;
		2)
			version='24.07-x86_64-linux'
			wget -qO "$playground/helix.tar.xz" "https://github.com/helix-editor/helix/releases/latest/download/helix-$version.tar.xz"
			tar -xf "$playground/helix.tar.xz" -C "$playground"
			sudo mv "$playground/helix-$version/hx" '/usr/local/bin'
			mv -f "$playground/helix-$version/runtime" "${XDG_CONFIG_HOME:-$HOME/.config}/helix"
			wget -qO "${XDG_CONFIG_HOME:-$HOME/.config}/helix/config.toml" 'https://raw.githubusercontent.com/ignamartinoli/kali/master/config.toml'
			;;
		*)
			continue
			;;
	esac

	break
done

message 'Unzipping wordlists'
sudo gunzip '/usr/share/wordlists/rockyou.txt.gz'

message 'Starting Metasploit database'
sudo msfdb init

message 'Installing tools'
sudo apt install \
	bettercap \
	bloodhound \
	crackmapexec \
	eaphammer \
	eyewitness \
	golang \
	hcxtools \
	sherlock \
	-qqy

message 'Installing Docker'
sudo apt install docker.io -qqy
sudo systemctl enable docker --now
sudo usermod -aG docker "$USER"

# TODO: installing wallapapers
# message 'Setting wallpaper'
# xfconf-query -c 'xfce4-desktop' -p '/backdrop/screen0/monitorVirtual1/workspace0/last-image' -s '/usr/share/backgrounds/kali-16x9/kali-metal-dark.png'

message 'Setup finished'
