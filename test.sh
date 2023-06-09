#!/bin/bash
exec sfdisk /dev/sda <<EOF
2048,1048576
,83886080
;
EOF

exec sfdisk --change-id /dev/sda 1 EF && mount /dev/sda1 /mnt/boot && mount /dev/sda2 /mnt && mount /dev/sda3 /mnt/home && mkdir /mnt/boot/efi

exec mkdir /mnt/boot /mnt/home /mnt/boot/efi
exec mount /dev/sda1 /mnt/boot
exec mount /dev/sda2 /mnt
exec mount /dev/sda3 /mnt/home
