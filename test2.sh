#!/bin/bash
exec mkdir /mnt/boot /mnt/home /mnt/boot/efi
exec sfdisk --change-id /dev/sda 1 EF

