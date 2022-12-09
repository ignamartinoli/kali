#!/bin/sh

# Updating Kali Linux

sudo apt update -y && sudo apt upgrade -y

sudo apt autoremove -y

# Upgrading Kali Linux

sudo apt update && sudo dist-upgrade -y

# Changing passwords

sudo passwd root

sudo passwd kali

# Installing drivers

sudo apt install realtek-rtl88xxau-dkms

# Installing Nerd Font

wget github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/FiraCode.zip

unzip -d $HOME/.local/share/fonts FiraCode.zip

rm FiraCode.zip

fc-cache -fv

# Installing Neovim

sudo apt install -y neovim

git clone --depth 1 https://github.com/wbthomason/packer.nvim $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim

# TODO: echo :PackerSync and set FiraCode Nerd Font
