#!/bin/bash
#Variables
echo "Do you BIOS or UEFI?"
echo "1)Bios    2)UEFI"
read boot
echo "Write a PC name (ex. server)"
read pc_name
echo "Write a root password (ex. 1234)"
read root_password
echo "Write a username (ex. giovanni_giorgio)"
read username
echo "Write a password for username (ex. qwerty)"
read username_password
#Configure system
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "${pc_name}" > /etc/hostname
echo "127.0.0.1	localhost" > /etc/hosts
echo "::1	      localhost" >> /etc/hosts
echo "127.0.0.1	${pc_name}.localdomain	${pc_name}"
systemctl enable NetworkManager
chpasswd <<<"root:${root_password}"
useradd ${username}
chpasswd <<<"${username}:${username_password}"
usermod -aG wheel ${username}
mkdir /home/${username}
chown ${username}:${username} /home/${username}
git clone https://github.com/OfficialKouling/arch /home/${username}/.shit_from_git
pacman -Sy grub efibootmgr sudo --noconfirm
echo "%sudo	ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
if [ $boot == 1 ]; then
    grub-install --target=i386-pc /dev/sda
elif [ $boot == 2 ]; then
    grub-install --target=x86_64-efi --efi-directory=/boot/efi
    grub-mkconfig -o /boot/grub/grub.cfg
    mkdir /boot/efi/EFI/boot
    cp /boot/efi/EFI/arch/grubx64.efi /boot/efi/EFI/boot/bootx64.efi
else
    echo "errr3r1oro1r46@!3ororor21415o12ro1213rorrrr"
fi
mv /arch /home/${username}
chown ${username}:${username} -R /home/${username}/arch
reboot
