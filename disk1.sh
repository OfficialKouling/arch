#!/bin/bash
fdisk -l | awk '/dev/ {print}'
echo "Write a disk name (ex. /dev/sda)"
read disk
echo "Write a PC name (ex. server)"
read pc_name
echo "Write a root password (ex. 1234)"
read root_password
echo "Write a username (ex. giovanni_giorgio)"
read username
echo "Write a password for username (ex. qwerty)"
read username_password
disk1="${disk}1"
disk2="${disk}2"
disk3="${disk}3"
disk4="${disk}4"

#Disk partitioning
sfdisk ${disk} <<EOF
2048,1077247,b
,16777216,S
,62914560,L
;
EOF
#sfdisk -n --part-type  ${disk} 2 0657FD6D-A4AB-43C4-84E5-0933C84B4F4F
#sfdisk -n --part-type  ${disk} 3 0FC63DAF-8483-4772-8E79-3D69D8477DE4
#sfdisk -n --part-type  ${disk} 4 0FC63DAF-8483-4772-8E79-3D69D8477DE4
#sfdisk -n --part-type ${disk} 1 BC13C2FF-59E6-4262-A352-B275FD6F7172
#Create File System
mkdir -p /mnt/boot /mnt/home /mnt/boot/efi
mkfs.fat -F 32 $disk1
mkswap $disk2
mkfs.ext4 $disk3
mkfs.ext4 $disk4
#Mount disks
swapon $disk2
mount ${disk3} /mnt
mount ${disk1} /mnt/boot/efi
mount ${disk4} /mnt/home
#Install system
pacstrap /mnt base base-devel linux linux-firmware vim git neofetch networkmanager
#Configure system
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt <<"EOT"
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "${pc_name}" > /etc/hostname
echo "127.0.0.1	localhost" > /etc/hosts
echo "::1	       localhost" >> /etc/hosts
echo "127.0.0.1	${pc_name}.localdomain	${pc_name}"
systemctl enable NetworkManager
chpasswd <<<"root:${root_password}"
useradd ${username}
chpasswd <<<"${username}:${username_password}"
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
mkdir /boot/efi/EFI/boot
cp /boot/efi/EFI/arch/grubx64.efi /boot/efi/EFI/boot/bootx64.efi
EOT
