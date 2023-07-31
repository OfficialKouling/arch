sudo pacman -Syu --noconfirm
sudo tar -xf ./cache/dwm-flexipatch.tar
sudo tar -xf ./cache/warpd.tar
sudo mkdir ~/.shit_from_git
sudo mv ./dwm-flexipatch ~/
sudo mv ./warpd ~/.shit_from_git/
sudo rm -Rf /etc/lightdm
sudo mv ./cache/lightdm /etc/lightdm
sudo pacman -Sy xorg flameshot light sxhkd lightdm kitty rofi lightdm-gtk-greeter accountsservice firefox xorg-server-xephyr lightdm-slick-greeter imlib2 xorg-xinit --noconfirm
sudo systemctl enable systemd-homed
sudo chown root:root -R /etc/lightdm
cd ~/dwm-flexipatch && sudo make install
cd ~/.shit_from_git/warpd && sudo make install
cd ~/arch/
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
cp -r ./cache/sxhkd ~/.config/
