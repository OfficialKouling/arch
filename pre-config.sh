sudo pacman -Syu --noconfirm
echo "Do you have a touchpad?"
echo "1)Yes 2)No"
read touchpad
echo "Which is your videocard?"
echo "1)AMD 2)Intel HD 3)Nvidia"
read video_card
sudo tar -xf ./cache/dwm-flexipatch.tar
sudo tar -xf ./cache/warpd.tar
sudo tar -xf ./cache/picom.tar
sudo mv ./dwm-flexipatch ~/
sudo mv ./picom ~/.shit_from_git/
sudo mv ./warpd ~/.shit_from_git/
sudo rm -Rf /etc/lightdm
sudo cp -r ./cache/lightdm /etc/lightdm
sudo pacman -Sy libx11 cmake libev uthash libconfig feh xorg meson ninja python flameshot light sxhkd lightdm kitty rofi lightdm-gtk-greeter accountsservice firefox xorg-server-xephyr lightdm-slick-greeter imlib2 xorg-xinit --noconfirm
sudo mkdir ~/.config/rofi
sudo cp -r ./cache/themes ~/.local/share/rofi
sudo echo '@theme "/home/kouling/.local/share/rofi/themes/spotlight-dark.rasi" ' > ~/.config/rofi/config.rasi
sudo cp -r ./cache/fonts /usr/share/
sudo cp -r ./cache/kitty ~/.config/
sudo systemctl enable systemd-homed
sudo chown root:root -R /etc/lightdm
#Video_card
if [ $video_card == 1 ]; then
    sudo pacman -Sy mesa xf86-video-amdgpu vulkan-radeon --noconfirm
    sudo cp -r ./cache/20-amdgpu.conf /etc/X11/xorg.conf.d/
elif [ $video_card == 2  ]; then
    sudo pacman -Sy mesa xf86-video-intel vulkan-intel --noconfirm
    sudo cp -r ./cache/20-intel.conf /etc/X11/xorg.conf.d/
elif [ $video_card == 3  ]; then
    sudo pacman -Sy mesa xf86-video-nouveau nvidia-utils --noconfirm
    sudo cp -r ./cache/20-nvidia.conf /etc/X11/xorg.conf.d
else
    echo "I'll install only mesa"
    sudo pacman -Sy mesa --noconfirm
fi
#Touchpad
if [ $touchpad == 1 ]; then
    sudo pacman -Sy libinput --noconfirm
    sudo cp -r ./cache/30-touchpad.conf /etc/X11/xorg.conf.d/
elif [ $touchpad == 2 ]; then
    echo "Ok"
else
    echo "Ok"
fi
cd ~/dwm-flexipatch && sudo make install
cd ~/.shit_from_git/warpd && sudo make install
cd ~/.shit_from_git/picom && meson --buildtype=release . build && ninja -C build
cd ~/arch
sudo su << "EOT"
sed 's/twm/#twm/' /etc/X11/xinit/xinitrc > /etc/X11/xinit/a1xinitrc1
sed 's/xclock/#xclock/' /etc/X11/xinit/a1xinitrc1 > /etc/X11/xinit/a1xinitrc2
sed 's/exec/#exec/' /etc/X11/xinit/a1xinitrc2 > /etc/X11/xinit/a1xinitrc3
sed 's/xterm/#xterm/'  /etc/X11/xinit/a1xinitrc3 > /etc/X11/xinit/a1xinitrc4
echo "exec dwm" >> /etc/X11/xinit/a1xinitrc4
sudo rm -rf /etc/X11/xinit/xinitrc
sudo cp -r /etc/X11/xinit/a1xinitrc4 /etc/X11/xinit/xinitrc
sudo rm -rf /etc/X11/xinit/a1xinitrc*
exit
EOT
sudo systemctl enable lightdm
sudo cp -r ./cache/script.sh ~/.
sudo cp -r ./cache/.xprofile ~/.
sudo mkdir ~/wallpapers
sudo cp -r ./cache/set.jpg ~/wallpapers/set.jpg
sudo cp -r ./cache/slick-greeter.conf /etc/lightdm/slick-greeter.conf
sudo cp -r ./cache/background.jpg /usr/share/background.jpg
sudo mkdir /usr/share/xsessions
sudo cp -r ./cache/dwm.desktop /usr/share/xsessions/dwm.desktop
sudo chown 644 /usr/share/xsessions/dwm.desktop
sudo cp -r ./cache/sxhkd.service /etc/systemd/system/sxhkd.service
sudo systemctl enable sxhkd.service
sudo cp -r ./cache/sxhkd ~/.config/
