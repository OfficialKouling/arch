sudo pacman -Syu --noconfirm
sudo tar -xf ./cache/dwm-flexipatch.tar
sudo mv ./dwm-flexipatch ~/
sudo pacman -Sy xorg lightdm xorg-server-xephyr lightdm-slick-greeter base-devel libx11 libxft libxinerama freetype2 fontconfig --noconfirm
sudo make install clear ~/dwm-flexipatch
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
