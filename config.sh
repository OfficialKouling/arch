sudo pacman -Syu --noconfirm
sudo tar -xf ./cache/dwm-flexipatch.tar
sudo mv ./dwm-flexipatch ~/
sudo pacman -Sy xorg lightdm kitty firefox xorg-server-xephyr lightdm-slick-greeter imlib2 xorg-xinit --noconfirm
cd ~/dwm-flexipatch && sudo make install clear
cd
sudo sed 's/twm/#twm/' /etc/X11/xinit/xinitrc
sudo sed 's/xclock/#xclock/' /etc/X11/xinit/xinitrc
sudo sed 's/exec/#exec/' /etc/X11/xinit/xinitrc
sudo sed 's/xterm/#xterm/' /etc/X11/xinit/xinitrc
sudo echo "exec dwm" >> /etc/X11/xinit/xinitrc
sudo systemctl enable lightdm
sudo cp -r ./cache/script.sh ~/.
sudo cp -r ./cache/.xprofile ~/.
sudo rm -rf /etc/lightdm/lightdm.conf
sudo cp -r ./cache/lightdm.conf /etc/lightdm/lightdm.conf
sudo mkdir ~/wallpapers
sudo cp -r ./cache/set.jpg ~/wallpapers/set.jpg
sudo cp -r ./cache/slick-greeter.conf /etc/lightdm/slick-greeter.conf
sudo cp -r ./cache/background.jpg /usr/share/background.jpg
sudo mkdir /usr/share/xsessions
sudo cp -r ./cache/dwm.desktop /usr/share/xsessions/dwm.desktop
sudo chown 644 /usr/share/xsessions/dwm.desktop
