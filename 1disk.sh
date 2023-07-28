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
2048,1077247
16777216
62914560
;
EOF
sfdisk -n --part-type  ${disk} 2 82
sfdisk -n --part-type  ${disk} 3 83
sfdisk -n --part-type  ${disk} 4 83
#Create File System
mkdir -p /mnt/boot /mnt/home /mnt/boot/efi && sfdisk --part-type $disk 1 EF
mkfs.fat -F 32 $disk1
mkswap $disk2
swapon $disk2
mkfs.ext4 $disk3
mkfs.ext4 $disk4
