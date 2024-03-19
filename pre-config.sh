#!/bin/bash
sudo pacman -Syu --noconfirm
echo "Select your style"
echo "1)Blue 2)Orange 3)Skyrim 4)Red Skull"
read theme
echo "Do you have a touchpad?"
echo "1)Yes 2)No"
read touchpad
echo "Which is your videocard?"
echo "1)AMD 2)Intel HD 3)Nvidia"
read video_card
echo "Do you want to install lightdm?"
echo "1)Yes 2)No"
read lightdm
sudo mkdir /usr/share/xsessions ~/wallpapers ~/.config ~/.config/neofetch ~/.config/kitty ~/.config/rofi ~/.config/ranger
sudo touch ~/.config/ranger/rc.conf
sudo echo "set preview_images true" >> ~/.config/ranger/rc.conf
sudo echo "set preview_images_method  ueberzug" >> ~/.config/ranger/rc.conf
sudo pacman -U ./cache/yay-12.1.3-1-x86_64.pkg.tar.zst --noconfirm
(cd .shit_from_git && git clone https://github.com/bakkeby/dwm-flexipatch)
sudo tar -xf ./cache/.vim_runtime.tar
sudo tar -xf ./cache/blur-grub2_fullhd.tar
sudo tar -xf ./cache/.zsh-vi-mode.tar
sudo tar -xf ./cache/warpd.tar
sudo tar -xf ./cache/picom.tar
sudo tar -xf ./cache/zsh-syntax-highlighting.tar
sudo tar -xf ./cache/.oh-my-zsh.tar
sudo tar -xf ./cache/powerlevel10k.tar
sudo tar -xf ./cache/dwmbar.tar
sudo mv ./.vim_runtime ~/
cd blur-grub2_fullhd/
sudo sh install.sh
cd ~/arch
if ! [[ -d ~/.shit_from_git/.zsh-vi-mode ]]; then
    if [[ $(diff -r ./.zsh-vi-mode ~/.shit_from_git/.zsh-vi-mode) != "" ]] || [[ $(diff -r ./.zsh-vi-mode ~/.shit_from_git/.zsh-vi-mode) -eq 0 ]]; then
        sudo mv ./.zsh-vi-mode ~/.shit_from_git/
    fi
fi
if ! [[ -d ~/powerlevel10k ]]; then
    if [[ $(diff -r ./powerlevel10k ~/powerlevel10k) != "" ]] || [[ $(diff -r ./powerlevel10k ~/powerlevel10k) -eq 0 ]]; then
        sudo mv ./powerlevel10k ~/
    fi
fi
if ! [[ -d ~/.oh-my-zsh ]]; then
    if [[ $(diff -r ./.oh-my-zsh ~/.oh-my-zsh) != "" ]] || [[ $(diff -r ./.oh-my-zsh ~/.oh-my-zsh) -eq 0 ]]; then
        sudo mv ./.oh-my-zsh ~/
    fi
fi
if ! [[ -d ~/.shit_from_git/dwmbar ]]; then
    if [[ $(diff -r ./dwmbar ~/.shit_from_git/dwmbar) != "" ]] || [[ $(diff -r ./dwmbar ~/.shit_from_git/dwmbar) -eq 0 ]]; then
        sudo mv ./dwmbar ~/.shit_from_git/
        cd ~/.shit_from_git/dwmbar && sudo ./install.sh
        cd ~/arch
    fi
fi
if ! [[ -d ~/.shit_from_git/zsh-syntax-highlighting ]]; then
    if [[ $(diff -r ./zsh-syntax-highlighting ~/.shit_from_git/zsh-syntax-highlighting) != "" ]] || [[ $(diff -r ./zsh-syntax-highlighting ~/.shit_from_git/zsh-syntax-highlighting) -eq 0 ]]; then
        sudo mv ./zsh-syntax-highlighting ~/.shit_from_git/
    fi
fi
if ! [[ -d ~/dwm-flexipatch ]]; then
    if [[ $(diff -r ./dwm-flexipatch ~/dwm-flexipatch) != "" ]] || [[ $(diff -r ./dwm-flexipatch ~/dwm-flexipatch) -eq 0 ]]; then
        sudo mv ./dwm-flexipatch ~/
        cd ~/dwm-flexipatch && sudo make install
        cd ~/arch
    fi
fi
if ! [[ -d ~/.shit_from_git/picom ]]; then
    if [[ $(diff -r ./picom ~/.shit_from_git/picom) != "" ]] || [[ $(diff -r ./picom ~/.shit_from_git/picom) -eq 0 ]]; then
        sudo mv ./picom ~/.shit_from_git/
        cd ~/.shit_from_git/picom && meson --buildtype=release . build && ninja -C build
        cd ~/arch
    fi
fi
if ! [[ -d ~/.shit_from_git/warpd ]]; then
    if [[ $(diff -r ./warpd ~/.shit_from_git/warpd) != "" ]] || [[ $(diff -r ./warpd ~/.shit_from_git/warpd) -eq 0 ]]; then
        sudo mv ./warpd ~/.shit_from_git/
        cd ~/.shit_from_git/warpd && make PREFIX=/usr && sudo make install PREFIX=/usr
        cd ~/arch
    fi
fi
sudo pacman -Sy libx11 pulseaudio libxinerama fontconfig libxft ttf-font-awesome python-pywal lsd bat thefuck cmake libev uthash libconfig feh xorg meson ninja --noconfirm
sudo pacman -Sy lxappearance-gtk3 python flameshot sxhkd lightdm kitty rofi lightdm-gtk-greeter accountsservice firefox xorg-server-xephyr lightdm-slick-greeter imlib2 xorg-xinit --noconfirm
sudo pacman -Sy python-ueberzug ranger --noconfirm
if [[ $lightdm == 1 ]]; then
    sudo pacman -Sy lightdm
    sudo rm -Rf /etc/lightdm
    sudo cp -r ./cache/lightdm /etc/lightdm
    sudo cp ./cache/slick-greeter.conf /etc/lightdm/slick-greeter.conf
    sudo cp ./cache/background.jpg /usr/share/background.jpg
    sudo systemctl enable lightdm
    sudo chown root:root -R /etc/lightdm
elif [[ $lightdm == 2 ]]; then
    echo "I don't install lightdm"
else
    echo "I don't install lightdm"
fi
sudo cp -r ./cache/themes/* /usr/share/rofi/themes/
sudo cp -r ./cache/fonts /usr/share/
sudo cp -r ./cache/kitty/kitty.conf ~/.config/kitty/
sudo cp ./cache/molokai.vim /usr/share/vim/vim90/colors/
sudo mv ./icons/Amy-Dark-Icons ~/.local/share/icons/
sudo mv ./icons/Sweet-cursors ~/.local/share/icons/
sudo mv ./icons/Amy-Dark-GTK.tar.gz ~/.local/share/themes/ && cd ~/.local/share/themes && tar -xf Amy-Dark-GTK.tar.gz && cd ~/arch
sudo cp ./cache/.vimrc ~/
sudo cp ./cache/picom.conf /etc/xdg/picom.conf
sudo cp ./cache/config.conf ~/.config/neofetch/
sudo systemctl enable systemd-homed
#Touchpad
if [[ $touchpad == 1 ]]; then
    sudo pacman -Sy libinput --noconfirm
    sudo cp -r ./cache/30-touchpad.conf /etc/X11/xorg.conf.d/
    yay -Sy ruby-fusuma --noconfirm
elif [[ $touchpad == 2 ]]; then
    echo "Ok"
else
    echo "Ok"
fi
sudo su << "EOT"
sed 's/twm/#twm/' /etc/X11/xinit/xinitrc > /etc/X11/xinit/a1xinitrc1
sed 's/xclock/#xclock/' /etc/X11/xinit/a1xinitrc1 > /etc/X11/xinit/a1xinitrc2
sed 's/exec/#exec/' /etc/X11/xinit/a1xinitrc2 > /etc/X11/xinit/a1xinitrc3
sed 's/xterm/#xterm/'  /etc/X11/xinit/a1xinitrc3 > /etc/X11/xinit/a1xinitrc4
echo "exec dwm" >> /etc/X11/xinit/a1xinitrc4
sudo rm -rf /etc/X11/xinit/xinitrc
sudo cp -r /etc/X11/xinit/a1xinitrc4 /etc/X11/xinit/xinitrc
sudo rm -rf /etc/X11/xinit/a1xinitrc*
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
exit
EOT
#Video_card
if [[ $video_card == 1 ]]; then
    sudo pacman -Sy mesa xf86-video-amdgpu vulkan-radeon --noconfirm
    sudo cp -r ./cache/20-amdgpu.conf /etc/X11/xorg.conf.d/
elif [[ $video_card == 2  ]]; then
    sudo pacman -Sy mesa xf86-video-intel vulkan-intel --noconfirm
    sudo cp -r ./cache/20-intel.conf /etc/X11/xorg.conf.d/
elif [[ $video_card == 3  ]]; then
    yay -Sy nvidia-vulkan --noconfirm
    sudo pacman -Sy nvidia vulkan-icd-loader lib32-nvidia-utils --noconfirm
    sudo nvidia-xconfig
    sudo cp -r ./cache/20-nvidia.conf /etc/X11/xorg.conf.d
else
    echo "I'll install only mesa"
    sudo pacman -Sy mesa --noconfirm
fi
sudo cp -r ./cache/script.sh ~/.
sudo cp -r ./cache/.xprofile ~/.
sudo cp -r ./cache/dwm.desktop /usr/share/xsessions/dwm.desktop
sudo chown 644 /usr/share/xsessions/dwm.desktop
sudo cp -r ./cache/sxhkd ~/.config/
