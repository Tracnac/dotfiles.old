#!/bin/env bash
PKGS="stow sxhkd xcompmgr dunst rofi dmenu"

# Default package
pacman -S --noconfirm ${PKGS}

cd ~/
git clone https://github.com/tracnac/dotfiles
cp dotfiles/dot-stowrc .stowrc
stow vim
stow tmux
stow bin
cd dotfiles
git submodule init
git submodule update
cd ~/
# vim :PlugUpgrade + :PlugInstall
# tmux ctrl-b shift i
# git clone https://aur.archlinux.org/cwm.git
# Build cwm + st
