exec sfdisk --change-id /dev/sda 1 EF

exec mount /dev/sda1 /mnt/boot
exec mount /dev/sda2 /mnt
exec mount /dev/sda3 /mnt/home

exec mkdir /mnt/boot/efi
