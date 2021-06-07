#!/bin/env bash
PKGS="sxhkd picom dunst rofi"

# Default package
pacman -S --noconfirm ${PKGS}


# Install yay
cd /opt
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R tracnac:users ./yay-git
cd yay-git
makepkg -si


cd ~/
git clone https://github.com/tracnac/dotfiles
cp dotfiles/dot-stowrc .stowrc
stow vim
stow tmux
stow bin
cd dotfiles
git submodule init
git submodule update
# git submodule update --init
cd ~/
# vim :PlugUpgrade + :PlugInstall
# tmux ctrl-b + shift i



# git clone https://aur.archlinux.org/cwm.git
# git clone https://aur.archlinux.org/st.git
# Build cwm + st (makepkg -si)

# https://github.com/adi1090x/polybar-themes
