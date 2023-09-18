#!/bin/sh

# cyan='\033[0;36m'

# echo "$cyan-=-=-=-=-=[ Changing root password ]=-=-=-=-=-"
sudo passwd root

# echo "$cyan-=-=-=-=-=[ Changing user password ]=-=-=-=-=-"
sudo passwd kali

# echo "$cyan-=-=-=-=-=[ Updating ]=-=-=-=-=-"
# sudo apt update -qqy && sudo apt upgrade -qqy
# sudo apt autoremove -qqy

# echo "$cyan-=-=-=-=-=[ Upgrading ]=-=-=-=-=-"
# sudo apt update -qqy && sudo apt dist-upgrade -qqy

# echo "$cyan-=-=-=-=-=[ Installing drivers ]=-=-=-=-=-"
# sudo apt install realtek-rtl88xxau-dkms -qqy

# echo "$cyan-=-=-=-=-=[ Adding keymaps ]=-=-=-=-=-"
sed -i '/backword-kill-line/a bindkey '\''^H'\'' backward-kill-word                   # ctrl + delete' "$HOME/.zshrc"
echo 'keycode 66 = Escape' > "$HOME/.Xmodmap"
xmodmap "$HOME/.Xmodmap"

# echo "$cyan-=-=-=-=-=[ Installing Nerd Font ]=-=-=-=-=-"
# fonts="$HOME/.local/share/fonts"
# wget -qO "$HOME/FiraCode.zip" 'github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip'
# [ -d "$fonts" ] || mkdir -p "$fonts" && unzip -od "$fonts" "$HOME/FiraCode.zip"
# rm "$HOME/FiraCode.zip"
# fc-cache -fv

# echo "$cyan-=-=-=-=-=[ Installing Neovim ]=-=-=-=-=-"
# wget -qO "$HOME/nvim-linux64.tar.gz" 'github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz'
# tar xzf "$HOME/nvim-linux64.tar.gz" -C "$HOME"
# rm "$HOME/nvim-linux64.tar.gz"
# sudo ln -s "$HOME/nvim-linux64/bin/nvim" '/usr/local/bin/nvim'
# sudo apt install npm ripgrep -qqy
# git clone 'https://github.com/NvChad/NvChad' "$HOME/.config/nvim" --depth 1
# TODO: sed "$HOME/.config/nvim/lua/custom/configs/overrides.lua"

# echo "$cyan-=-=-=-=-=[ SETUP FINISHED ]=-=-=-=-=-"
