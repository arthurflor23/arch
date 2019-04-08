#!/bin/bash

echo "Do you want to start?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done

user_name=$(whoami)
desktop=$(echo $DESKTOP_SESSION | grep -Eo "plasma|gnome")

### AUR (pikaur)
    git clone https://aur.archlinux.org/pikaur.git && cd pikaur && makepkg -fsri && cd - && sudo rm -R pikaur

    echo -e "
    pkgin(){ pikaur -S \$@; }
    pkgre(){ pikaur -Rcc \$@; }
    pkgse(){ pikaur -Ss \$@; }
    pkgup(){ pikaur -Syyu; }
    pkgcl(){ pikaur -Scc; orphan=\$(pikaur -Qtdq) && pikaur -Rns \$orphan; }
    " | sudo tee --append ~/.bashrc

### Common packages 
    pikaur -S wd719x-firmware aic94xx-firmware --noconfirm
    pikaur -S jre multibootusb keepassxc --noconfirm
    pikaur -S virtualbox virtualbox-guest-iso virtualbox-ext-oracle --noconfirm

    pikaur -S libreoffice-fresh libreoffice-fresh-pt-br libreoffice-extension-languagetool --noconfirm
    pikaur -S pdfarranger hunspell-en_US hunspell-pt-br --noconfirm

    pikaur -S google-chrome qbittorrent gimp vlc --noconfirm
    pikaur -S korla-icon-theme --noconfirm

    pikaur -S smartgit visual-studio-code-bin --noconfirm
    pikaur -S opencv python-{matplotlib,numpy,pylint,tensorflow-opt} --noconfirm
    # vtk glew

### Games
    cd ~ && wget -c https://download.wakfu.com/full/linux/x64 -O - | tar -xz
    mkdir -p ~/.local/share/applications/ && mv Wakfu .wakfu && cd -

    echo -e "
    [Desktop Entry]
    Encoding=UTF-8
    Type=Application
    Name=Wakfu
    Icon=/home/$user_name/.wakfu/game/icon.png
    Exec=optirun /home/$user_name/.wakfu/Wakfu
    Categories=Game" | sudo tee --append ~/.local/share/applications/wakfu.desktop


### Custom packages and settings to KDE
if [ $desktop == "plasma" ] ; then
    ### -- | shortcuts | --
    ## launcher: monitor, dolphin, google-chrome, qbittorrent 
    ## kwin: show desktop

    sudo sed -i 's/margins.bottom;/margins.bottom + 4;/' /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/ui/code/layout.js
    
### Custom packages and settings to Gnome
elif [ $desktop == "gnome" ] ; then
    ### -- | shorcuts | --
    ## print   : gnome-screenshot --interactive
    ## terminal: gnome-terminal
    ## monitor : gnome-system-monitor
    ## xkill   : xkill
    ## nautilus: nautilus --new-window
    ## desktop : ocultar todas as janelas normais

    ### -- | extensions | --
    ## AlternateTab
    ## Arch Linux Updates Indicator
    ## Bumblebee Status
    ## Clipboard Indicator
    ## Dash to Dock
    ## Dynamic Panel Transparency
    ## GSConnect
    ## OpenWeather
    ## Sound Input & Output Device Chooser
    ## Status Area Horizontal Spacing
    ## TopIcons Plus

    ### Remove packages unused
    sudo pacman -Rcc gnome-{boxes,calendar,characters,clocks,contacts,dictionary,documents,font-viewer,getting-started-docs,logs,maps,music,shell-extensions,todo,video-effects}
    sudo pacman -Rcc baobab evolution evolution-data-server rygel totem xdg-user-dirs-gtk vino yelp

    ### Gnome settings
    echo -e "HandleLidSwitch=lock" | sudo tee --append /etc/systemd/logind.conf
    gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 0
fi

### Clear
orphan=$(sudo pacman -Qtdq) 

sudo pacman -Scc; 
sudo pacman -Rns $orphan;

### -- | nvidia tips | --
## nvidia settings: optirun nvidia-settings -c :8
## Steam (nvidia): LD_PRELOAD='/usr/lib/nvidia/libGL.so' optirun %command%