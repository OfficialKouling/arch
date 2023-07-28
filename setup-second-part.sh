#!/bin/bash
#Variables
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
usermod -aG wheel kouling
pacman -Sy grub efibootmgr sudo --noconfirm
echo "%sudo	ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
grub-install --target=x86_64-efi --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
mkdir /boot/efi/EFI/boot
cp /boot/efi/EFI/arch/grubx64.efi /boot/efi/EFI/boot/bootx64.efi
