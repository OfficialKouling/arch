#!/bin/bash
#Variables
username=$(ls /home | awk '/^[^lost+found]/ { print $1 }')
trap exit_user INT
exit_user() {
    echo "exiting.." ; exit 1
}
banner () {
    gum style \
        --foreground 212 --border-foreground 212 --border double \
        --align center --width 50 --margin "1 2" --padding "2 4" \
        "$_text"
}
#Packages
sudo pacman -Syu --noconfirm
sudo pacman -Sy libx11 pulseaudio libxinerama fontconfig libxft ttf-font-awesome python-pywal --noconfirm
sudo pacman -Sy lsd bat thefuck cmake libev uthash libconfig feh xorg meson ninja --noconfirm
sudo pacman -Sy lxappearance-gtk3 python flameshot sxhkd lightdm kitty rofi lightdm-gtk-greeter --noconfirm
sudo pacman -Sy accountsservice firefox xorg-server-xephyr lightdm-slick-greeter imlib2 xorg-xinit --noconfirm
sudo pacman -Sy pulsemixer python-ueberzug ranger zsh curl gum ttf-hack wget --noconfirm
#User variables
clear
_text="Select your style" && banner
theme="$(gum choose --limit 1 "Blue, Harry Potter" "Orange, Arch logo" "Blue, Skyrim logo" "Red skull" "My own")" && clear
_text="Do you have a touchpad?" && banner
touchpad="$(gum choose --limit 1 Yes No)" && clear
_text="Which is your videocard?" && banner
video_card="$(gum choose --limit 1 AMD Intel Nvidia "No driver")" && clear
#Script
tar -xvjf icons.tar.bz2
sudo mkdir /usr/share/xsessions ~/.local ~/.local/share ~/.local/share/themes ~/wallpapers ~/.shit_from_git ~/.config ~/.config/neofetch ~/.config/kitty ~/.config/rofi ~/.config/ranger
sudo chown ${username}:${username} -R /home/${username}
touch ~/.config/ranger/rc.conf
echo "set preview_images true" > ~/.config/ranger/rc.conf
echo "set preview_images_method ueberzug" >> ~/.config/ranger/rc.conf
(cd ~/.shit_from_git && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -sri)
sudo pacman -U ~/.s/yay-12.1.3-1-x86_64.pkg.tar.zst --noconfirm
tar -xvf ./vim/.vim_runtime.tar
mv ./.vim_runtime ~/
(cd blur-grub2_fullhd/ && sudo sh install.sh)
(cd ~ && git clone https://github.com/bakkeby/dwm-flexipatch && cp -r ~/arch/dwm-flexipatch ~ && cd ~/dwm-flexipatch && sh script.sh ~/wallpapers/set.jpg && sudo make install clean)
(cd ~/.shit_from_git && git clone https://github.com/jeffreytse/zsh-vi-mode)
(cd ~/.shit_from_git && git clone https://github.com/thytom/dwmbar && cd dwmbar && cp ~/arch/dwmbar/config . && sudo ./install.sh)
(cd ~/.shit_from_git && git clone https://github.com/zsh-users/zsh-syntax-highlighting)
(cd ~/.shit_from_git && git clone https://github.com/FT-Labs/picom && cd picom && meson --buildtype=release . build && ninja -C build)
(cd ~/.shit_from_git && git clone https://github.com/rvaiya/warpd && cd warpd && make PREFIX=/usr && sudo make install PREFIX=/usr)
if [[ $theme == "Blue, Harry Potter" ]]; then
    sh ./dwm-flexipatch/script.sh ./wallpapers/"Blue, Harry Potter.jpg"
elif [[ $theme == "Orange, Arch logo" ]]; then
    sh ./dwm-flexipatch/script.sh ./wallpapers/"Orange, Arch logo.jpg"
elif [[ $theme == "Blue, Skyrim logo" ]]; then
    sh ./dwm-flexipatch/script.sh ./wallpapers/"Blue, Skyrim logo.jpg"
elif [[ $theme == "Red skull" ]]; then
    sh ./dwm-flexipatch/script.sh ./wallpapers/"Red skull.jpg"
elif [[ $theme == "My own" ]]; then
    sh ./dwm-flexipatch/script.sh ./wallpapers/*.jpg
else
    echo "no wallpaper selected"
fi
sudo rm -rf /etc/lightdm
sudo cp -r ./lightdm /etc/lightdm
sudo cp ./wallpapers/background.jpg /usr/share/background.jpg
sudo systemctl enable lightdm
sudo cp -r ./rofi/themes/* /usr/share/rofi/themes/
sudo cp -r ./fonts /usr/share/
cp -r ./kitty/kitty.conf ~/.config/kitty/
sudo cp ./vim/molokai.vim /usr/share/vim/vim90/colors/
cp -r ./icons/Amy-Dark-Icons ~/.local/share/icons/
cp -r ./icons/Sweet-cursors ~/.local/share/icons/
cp -r ./icons/Amy-Dark-GTK ~/.local/share/themes/
cp ./vim/.vimrc ~/
sudo cp ./picom/picom.conf /etc/xdg/picom.conf
cp ./neofetch/config.conf ~/.config/neofetch/
sudo systemctl enable systemd-homed
#Touchpad
if [[ $touchpad == "Yes" ]]; then
    sudo pacman -Sy libinput --noconfirm
    sudo cp -r ./xorg/30-touchpad.conf /etc/X11/xorg.conf.d/
    yay -Sy ruby-fusuma --noconfirm
else
    echo "Ok"
fi
sudo su << EOF
sed -i "s/twm/#twm/" /etc/X11/xinit/xinitrc
sed -i "s/xclock/#xclock/" /etc/X11/xinit/xinitrc
sed -i "s/exec/#exec/" /etc/X11/xinit/xinitrc
sed -i "s/xterm/#xterm/"  /etc/X11/xinit/xinitrc
echo "exec dwm" >> /etc/X11/xinit/xinitrc
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
EOF
#Keyboard
sudo cp ./xorg/00-keyborad.conf /etc/X11/xorg.conf.d/
#Video_card
if [[ $video_card == "AMD" ]]; then
    sudo pacman -Sy mesa xf86-video-amdgpu vulkan-radeon --noconfirm
    sudo cp ./xorg/20-amdgpu.conf /etc/X11/xorg.conf.d/
elif [[ $video_card == "Intel"  ]]; then
    sudo pacman -Sy mesa xf86-video-intel vulkan-intel --noconfirm
    sudo cp ./xorg/20-intel.conf /etc/X11/xorg.conf.d/
elif [[ $video_card == "Nvidia"  ]]; then
    yay -Sy nvidia-vulkan --noconfirm
    sudo pacman -Sy nvidia vulkan-icd-loader lib32-nvidia-utils --noconfirm
    sudo nvidia-xconfig
    sudo cp ./xorg/20-nvidia.conf /etc/X11/xorg.conf.d
else
    echo "I'll install only mesa"
   sudo pacman -Sy mesa --noconfirm
fi
cp -r picom.sh ~/
touch ~/picom.sh && echo "#!/bin/bash" > ~/picom.sh && echo "~/.shit_from_git/picom/build/src/picom -b -f" >> ~/picom.sh
cp -r ./.xprofile ~/
sudo cp -r ./lightdm/dwm.desktop /usr/share/xsessions/dwm.desktop
sudo chown 644 /usr/share/xsessions/dwm.desktop
cp -r ./sxhkd ~/.config/
chsh -s $(which zsh)
(sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)") && cp ./.zshrc ~/
(git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k)
(git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions)
(git clone https://github.com/jeffreytse/zsh-vi-mode \
  $ZSH_CUSTOM/plugins/zsh-vi-mode)

