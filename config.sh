#!/bin/bash
sudo su << "EOT"
sed 's/#greeter-session=lightdm-slick-greeter/greeter-session=lightdm-slick-greeter/' /etc/lightdm/lightdm.conf > /etc/lightdm/lightdm1.conf
rm -Rf /etc/lightdm/lightdm.conf
mv /etc/lightdm/lightdm1.conf /etc/lightdm/lightdm.conf
EOT
sudo pacman -Syu --noconfirm
sudo pacman -Sy zsh curl --noconfirm
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sudo cp -r ./cache/.zshrc ~/
