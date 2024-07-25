#!/bin/bash

echo "
███╗░░░███╗░█████╗░██╗░░██╗██╗░░██╗░░░░██╗███████╗███╗░░██╗██╗░░░██╗
████╗░████║██╔══██╗╚██╗██╔╝╚██╗██╔╝░░░██╔╝██╔════╝████╗░██║██║░░░██║
██╔████╔██║██║░░██║░╚███╔╝░░╚███╔╝░░░██╔╝░█████╗░░██╔██╗██║╚██╗░██╔╝
██║╚██╔╝██║██║░░██║░██╔██╗░░██╔██╗░░██╔╝░░██╔══╝░░██║╚████║░╚████╔╝░
██║░╚═╝░██║╚█████╔╝██╔╝╚██╗██╔╝╚██╗██╔╝░░░███████╗██║░╚███║░░╚██╔╝░░
╚═╝░░░░░╚═╝░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░░░╚══════╝╚═╝░░╚══╝░░░╚═╝░░░
"

sleep 2
echo -e "\tEntorno - Script de instalacion automatizada."
echo -e "\t\t𝐴𝑛𝑑𝑟𝑒𝑠 𝐺𝑎𝑟𝑐𝑖𝑎 (Aka. 𝐌𝟎𝐱𝐗)"
sleep 3
echo -e "\nIniciando instalacion..\n"
sleep 4

distro=$(lsb_release -is)

echo -e "\e[1;34mActualizando el sistema...\e[0m"

if [ "$distro" == "Kali" ]; then
  sudo apt update && sudo apt upgrade -y
elif [ "$distro" == "Parrot" ]; then
  sudo apt update && parrot-upgrade -y
fi

echo -e "\e[1;34mInstalando dependencias necesarias...\e[0m"
sleep 2
sudo apt install -y neovim bspwm kitty build-essential git vim libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev kitty libxinerama1 libxinerama-dev cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libuv1-dev libnl-genl-3-dev libxinerama1 libxinerama-dev meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev bspwm libpcre3 libpcre3-dev libxinerama-dev
 
if [ "$distro" == "Kali" ]; then
  sudo apt update && sudo apt upgrade -y
elif [ "$distro" == "Parrot" ]; then
  sudo apt update && parrot-upgrade -y
fi

echo -e "\e[1;34mCreando y limpiando directorios...\e[0m"
sleep 1
cd ~
rm -rf Documents Music Pictures Public Videos Documentos Música Público Vídeos
mkdir Utilidades
cd Utilidades
mkdir WebScripts
mkdir Other

echo -e "\e[1;34mClonando repositorios...\e[0m"
sleep 1
git clone http://github.com/M0xX25/MyScripts.git
cd WebScripts
git clone  http://github.com/baskerville/bspwm.git
git clone http://github.com/baskerville/sxhkd.git

echo -e "\e[1;34mCompilando e instalando bspwm...\e[0m"
sleep 1
cd bspwm
make || { echo -e "\e[1;31mFallo al compilar bspwm\e[0m"; exit 1; }
sudo make install || { echo -e "\e[1;31mFallo al instalar bspwm\e[0m"; exit 1; }

cd ../sxhkd
echo -e "\e[1;34mCompilando e instalando sxhkd...\e[0m"
sleep 1
make || { echo -e "\e[1;31mFallo al compilar sxhkd\e[0m"; exit 1; }
sudo make install || { echo -e "\e[1;31mFallo al instalar sxhkd\e[0m"; exit 1; }

echo -e "\e[1;34mConfigurando bspwm y sxhkd...\e[0m"
sleep 1
mkdir -p ~/.config/{bspwm,sxhkd}
chmod +x ../bspwm/examples/bspwmrc
cp ../bspwm/examples/bspwmrc ~/.config/bspwm/
cp ../bspwm/examples/sxhkdrc ~/.config/sxhkd/
mkdir -p ~/.config/bspwm/scripts/
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

chmod +x ~/.config/bspwm/scripts/bspwm_resize

echo -e "\e[1;34mClonando y compilando polybar...\e[0m"
sleep 1
cd ../../
git clone --recursive https://github.com/polybar/polybar
cd polybar/
mkdir build
cd build/
cmake .. || { echo -e "\e[1;31mFallo al ejecutar cmake para polybar\e[0m"; exit 1; }
make -j$(nproc) || { echo -e "\e[1;31mFallo al compilar polybar\e[0m"; exit 1; }
sudo make install || { echo -e "\e[1;31mFallo al instalar polybar\e[0m"; exit 1; }

echo -e "\e[1;34mClonando y compilando picom...\e[0m"
sleep 1
cd ../..
git clone https://github.com/ibhagwan/picom.git
cd picom/
git submodule update --init --recursive
meson --buildtype=release . build || { echo -e "\e[1;31mFallo al ejecutar meson para picom\e[0m"; exit 1; }
ninja -C build || { echo -e "\e[1;31mFallo al compilar picom\e[0m"; exit 1; }
sudo ninja -C build install || { echo -e "\e[1;31mFallo al instalar picom\e[0m"; exit 1; }

echo -e "\e[1;34mCopiando archivos de configuración...\e[0m"
sleep 1
cd ~
cp -r /home/m0xx/Entorno/home-m0xx/* ~
cp -r /home/m0xx/Entorno/home-root/.config /root
cp -r /home/m0xx/Entorno/home-root/.fehbg /root
cp -r /home/m0xx/Entorno/home-root/.p10k.zhs /root
cp -r /home/m0xx/Entorno/home-root/.zsh_history /root

chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/bspwm/scripts/bspwm_resize
chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/polybar/forest/scripts/target.sh
chmod +x ~/.config/polybar/forest/scripts/screenshot.sh

echo -e "\e[1;34mInstalando las fonts correspondientes...\e[0m"
mkdir /tmp/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip -O /tmp/fonts/Hack.zip
unzip /tmp/fonts/Hack.zip -d /tmp/fonts
font-manager -i /tmp/fonts/*.ttf

echo -e "\e[1;34mConfigurando powerlevel10k...\e[0m"
sleep 1
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k/
sudo echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>/root/.zshrc

echo -e "\e[1;34mCreando enlace simbólico para .zshrc de root...\e[0m"
sleep 1
sudo ln -sf /home/m0xx/.zshrc /root/.zshrc

echo -e "\e[1;32mEl entorno fue completamente instalado en el dispositivo.\e[0m"
