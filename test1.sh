#!/bin/bash
exec sfdisk --change-id /dev/sda 1 EF && mount /dev/sda1 /mnt/boot && mount /dev/sda2 /mnt && mount /dev/sda3 /mnt/home && mkdir /mnt/boot/efi
