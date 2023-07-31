#!/bin/bash
sudo su << "EOT"
sed 's/#greeter-session=lightdm-slick-greeter/greeter-session=lightdm-slick-greeter/' /etc/lightdm/lightdm.conf > /etc/lightdm/lightdm1.conf
rm -Rf /etc/lightdm/lightdm.conf
mv /etc/lightdm/lightdm1.conf /etc/lightdm/lightdm.conf
EOT
sudo pacman -Syu --noconfirm
