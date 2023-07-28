#!/bin/bash
fdisk -l | awk '/dev/ {print}'
echo "Write a disk name (ex. /dev/sda)"
read disk
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
mkfs.fat -F 32 $disk1 &&
mkswap $disk2 &&
mkfs.ext4 $disk3 &&
mkfs.ext4 $disk4 &&
#Mount disks
swapon $disk2
mount --mkdir ${disk3} /mnt
mount --mkdir ${disk1} /mnt/boot/efi
mount --mkdir ${disk4} /mnt/home
#Install system
pacstrap /mnt base base-devel linux linux-firmware vim git neofetch networkmanager
#Configure system
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt <<"EOT"
git clone https://github.com/OfficialKouling/arch
cd arch
EOT
arch-chroot /mnt
