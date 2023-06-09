#!/bin/bash
sfdisk /dev/sda <<EOF
2048,1048576
,83886080
;
EOF
mkdir -p /mnt/boot /mnt/home /mnt/boot/efi && sfdisk --change-id /dev/sda 1 EF
mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda3
mount /dev/sda1 /mnt/boot && mount /dev/sda2 /mnt && mount /dev/sda3 /mnt/home
