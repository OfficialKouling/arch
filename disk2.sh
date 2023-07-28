#!/bin/bash
exec mkdir /mnt/boot /mnt/home /mnt/boot/efi && sfdisk --change-id /dev/sda 1 EF

