#!/bin/bash

### SYSTEM ###

sudo sed -i 's/loglevel=3/loglevel=3 quiet/g' /etc/default/grub
sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo -e "en_US.UTF-8 UTF-8" | sudo tee --append /etc/locale.gen && sudo locale-gen
echo -e "FONT=lat0-16" | sudo tee --append /etc/vconsole.conf

sudo mkdir -p /etc/systemd/coredump.conf.d/
echo -e "[Coredump]\nStorage=none" | sudo tee --append /etc/systemd/coredump.conf.d/custom.conf
echo "SystemMaxUse=50M" | sudo tee --append /etc/systemd/journald.conf

sudo sed -i "s/#AutoEnable=false/AutoEnable=true/g" /etc/bluetooth/main.conf
echo -e "HandleLidSwitch=lock" | sudo tee --append /etc/systemd/logind.conf

gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 0

### PACKAGES ###

yay -Rcc baobab epiphany evolution-data-server rygel totem xdg-user-dirs-gtk vino vim yelp
yay -Rcc gnome-{books,characters,clocks,dictionary,disk-utility,documents,font-viewer,logs,music,photos,shell-extensions,software,weather}

yay -S pacman-contrib base-devel fakeroot neofetch gnome-{passwordsafe,multi-writer,tweaks}
yay -S gst-libav p7zip unrar sshfs bluez-hid2hci bluez-plugins bluez-tools ffmpegthumbnailer
yay -S xdotool gparted pdfarranger system-config-printer cups cups-filters cups-pdf
yay -S ttf-liberation ttf-ms-fonts adobe-source-han-sans-otc-fonts
yay -S wd719x-firmware aic94xx-firmware

yay -S jre8-openjdk google-chrome chrome-gnome-shell transmission-gtk gimp mpv pamac-aur smartgit visual-studio-code-bin
yay -S libreoffice-{fresh,extension-languagetool} hunspell-{en_US,pt-br} hyphen-{en,pt-br} libmythes mythes-{en,pt-br}

yay -c && yay -Scc

### WAKFU ###

cd ~ && wget -c https://download.ankama.com/launcher/full/linux/x64 -O wakfu
chmod +x wakfu

mkdir -p ~/.config/Ankama/ && mv ./wakfu ~/.config/Ankama/
sudo ln -s ~/.config/Ankama/wakfu /usr/bin/wakfu

echo -e "
[Desktop Entry]
Type=Application
Name=Wakfu
Icon=/home/$(whoami)/.config/Ankama/zaap/wakfu/icon.png
Exec=wakfu\nCategories=Game" > ~/.local/share/applications/wakfu.desktop

### ENVIRONMENT ###

sudo systemctl enable org.cups.cupsd
sudo systemctl enable avahi-daemon.service

cd /usr/share/applications && sudo rm cups.desktop pamac-updater.desktop && cd -

mv ~/Área\ de\ trabalho ~/Code
sed -i "s/Área de trabalho/Code/g" ~/.config/user-dirs.dirs && xdg-user-dirs-update

mkdir -p ~/.config/autostart/
echo -e "
[Desktop Entry]
Type=Application
Name=transmission-gtk
Exec=transmission-gtk -m" > ~/.config/autostart/transmission-gtk.desktop

echo -e "
activate(){
  python -m venv .venv ; source .venv/bin/activate ;
  pip install --upgrade -q pip ; pip install -q flake8 autopep8 ;
}" >> ~/.bashrc

echo -e "
autoclick(){
  while [ 1 ]; do
    sleep 5 ; xdotool mousemove 737 187 click 1 ;
    sleep 5 ; xdotool mousemove 1677 187 click 1 ;
  done
}" >> ~/.bashrc

### SHORCUTSS ###

## print   : gnome-screenshot --interactive
## terminal: gnome-terminal
## monitor : gnome-system-monitor
## xkill   : xkill
## nautilus: nautilus --new-window
## desktop : ocultar todas as janelas normais
## Trocar para o espaço de trabalho

### EXTENSIONS ###

## AlternateTab
## Clipboard Indicator
## Dash to Dock
## Dynamic Panel Transparency
## GSConnect
## OpenWeather
## Pamac Updates Indicator
## Sound Input & Output Device Chooser
## Status Area Horizontal Spacing
## Top Panel Workspace Scroll
## Transparent Top Bar
