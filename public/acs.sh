#!/usr/bin/env bash

if [[ $EUID > 0 ]]
    then echo "Please run with sudo"
    exit
fi

INSTALL_USER=$SUDO_USER
INSTALL_HOME="$(eval echo ~$INSTALL_USER)"

pacman -S --noconfirm git vim xf86-video-fbdev xorg xorg-xinit nitrogen picom firefox base-devel xonsh

mkdir -p "$INSTALL_HOME/github"

# dwm
git clone https://github.com/vincent-uden/dwm "$INSTALL_HOME/github/dwm"
cd "$INSTALL_HOME/github/dwm"
make install

# st
git clone https://github.com/vincent-uden/st "$INSTALL_HOME/github/st"
cd "$INSTALL_HOME/github/st"
make install

# xinitrc
curl -S http://vincentuden.xyz/xinitrc > "$INSTALL_HOME/.xinitrc"
curl -S http://vincentuden.xyz/bash_profile > "$INSTALL_HOME/.bash_profile"
