#!/usr/bin/env bash

pacman -S --noconfirm git vim xf86-video-fbdev xorg xorg-init nitrogen picom firefox base-devel xonsh

mkdir -p ~/github
git clone https://github.com/vincent-uden/dwm ~/github/dwm
cd ~/github/dwm
make install
