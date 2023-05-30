#!/bin/bash
exec sfdisk /dev/sda <<EOF
2048,1048576
,83886080
;
EOF

exec sfdisk --change-id /dev/sda 1 EF

exec mount /dev/sda1 /mnt/boot
exec mount /dev/sda2 /mnt
exec mount /dev/sda3 /mnt/home

exec mkdir /mnt/boot/efi

