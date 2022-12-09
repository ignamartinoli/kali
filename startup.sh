#!/bin/sh

# Updating Kali Linux

sudo apt update -y && sudo apt upgrade -y
sudo apt autoremove -y

# Upgrading Kali Linux

sudo apt update && sudo apt dist-upgrade -y

# Changing passwords

sudo passwd root
sudo passwd kali

# Installing drivers

sudo apt install realtek-rtl88xxau-dkms

# Installing Nerd Font

# wget github.com/ryanoasis/nerd-fonts/releases/download/v2.3.0-RC/FiraCode.zip
# unzip -d $HOME/.local/share/fonts FiraCode.zip
# rm FiraCode.zip
# fc-cache -fv

# Installing Neovim

wget github.com/neovim/neovim/releases/download/v0.8.1/nvim-linux64.deb
sudo apt install ./nvim-linux64.deb
rm -rf nvim-linux64.deb
