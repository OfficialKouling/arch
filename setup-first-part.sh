#!/bin/bash
echo "Do you have BIOS or UEFI?"
echo "1)Bios    2)UEFI"
read boot
fdisk -l | awk '/dev/ {print}'
echo "Write a disk name (ex. /dev/sda)"
read disk
echo "Do you want to install linux-zen? (select number) 1)Yes 2)No"
read zen
disk1="${disk}1"
disk2="${disk}2"
disk3="${disk}3"
disk4="${disk}4"
#Disk partitioning
sfdisk ${disk} <<EOF
2048,525M,b
,8000M,S
,20000M,L
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
if [ $boot == 1 ]; then
    mount --mkdir ${disk1} /mnt/boot
elif [ $boot == 2 ]; then
    mount --mkdir ${disk1} /mnt/boot/efi
else
    mount --mkdir ${disk1} /mnt/boot/efi
fi
mount --mkdir ${disk4} /mnt/home
#Install system
if [ $zen == 2 ]; then
    pacstrap /mnt base base-devel linux linux-firmware vim git neofetch networkmanager
elif [ $zen == 1 ]; then
    pacstrap /mnt base base-devel linux-zen linux-zen-headers vim git neofetch networkmanager
else
    pacstrap /mnt base base-devel linux linux-firmware vim git neofetch networkmanager
fi
#Configure system
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt <<"EOT"
git clone https://github.com/OfficialKouling/arch
echo ${disk2}
cd arch
EOT
arch-chroot /mnt
