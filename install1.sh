#!/bin/bash
exec pacstrap -K /mnt base linux linux-firmware
exec genfstab -U /mnt >> /mnt/etc/fstab
exec arch-chroot /mnt
exec ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
exec hwclock --systohc
exec echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
exec touch /etc/locale.conf
exec echo "LANG=en_US.UTF-8" > /etc/locale.conf
exec touch /etc/hostname
exec echo "arch-koul" > /etc/hostname
exec pacman -Syu sudo
exec useradd kouling
exec usermod -aG wheel kouling
