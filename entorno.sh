#!/bin/bash

# Actualizar el sistema
distro=$(lsb_release -is)

if [ "$distro" == "Kali" ]; then
  sudo apt update && sudo apt upgrade -y
elif [ "$distro" == "Parrot" ]; then
  sudo apt update && parrot-upgrade -y
fi

sudo apt install -y neovim kitty build-essential git vim libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev kitty libxinerama1 libxinerama-dev cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libuv1-dev libnl-genl-3-dev libxinerama1 libxinerama-dev meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev bspwm libpcre3 libpcre3-dev

cd ~
rm -rf Documents Music Pictures Public Videos Documentos Música Público Vídeos
mkdir Utilidades
cd Utilidades
mkdir WebScripts
mkdir Other
git clone http://github.com/M0xX25/MyScripts.git
cd WebScripts
git clone  http://github.com/baskerville/bspwm.git
git clone http://github.com/baskerville/sxhkd.git
cd bspwm
make
sudo make install
cd ../sxhkd
make
sudo make install
cd ../bspwm/examples
mkdir ~/.config/{bspwm,sxhkd}
chmod +x bspwmrc
cp bspwmrc ~/.config/bspwm/
cp sxhkdrc ~/.config/sxhkd/
mkdir /home/m0xx/.config/bspwm/scripts/
echo '#!/usr/bin/env dash

if bspc query -N -n focused.floating > /dev/null; then
        step=20
else
        step=100
fi

case "$1" in
        west) dir=right; falldir=left; x="-$step"; y=0;;
        east) dir=right; falldir=left; x="$step"; y=0;;
        north) dir=top; falldir=bottom; x=0; y="-$step";;
        south) dir=top; falldir=bottom; x=0; y="$step";;
esac

bspc node -z "$dir" "$x" "$y" || bspc node -z "$falldir" "$x" "$y"' > /home/m0xx/.config/bspwm/scripts/bspwm_resize

chmod +x /home/m0xx/.config/bspwm/scripts/bspwm_resize
cd ../../
git clone --recursive https://github.com/polybar/polybar
cd polybar/
mkdir build
cd build/
cmake ..
make -j$(nproc)
sudo make install
cd ../..
git clone https://github.com/ibhagwan/picom.git
cd picom/
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
sudo ninja -C build install
