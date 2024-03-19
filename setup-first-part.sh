#!/bin/bash
pacman -S gum --noconfirm
clear
gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	'Do you have BIOS or UEFI?'
boot="$(gum choose --limit 1 BIOS UEFI)"
clear
lsblk | awk '{print $1, $4}'
gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	'Which is your disk? (ex. /dev/sda)'
disk="$(gum choose --limit 1 /dev/sda /dev/sdb /dev/sdd /dev/nvme0n1p)"
clear
gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	'Give me size of SWAP partition'
swap_size="$(gum choose --limit 1 8000M 4000M 2000M 1000M)"
clear
gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	'Give me size of root partition'
root_size="$(gum choose --limit 1 60000M 40000M 20000M 10000M)"
clear
gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	'Do you want to install linux-zen?'
zen="$(gum choose --limit 1 Yes No)"
clear
disk1="${disk}1"
disk2="${disk}2"
disk3="${disk}3"
disk4="${disk}4"
#Disk partitioning
sfdisk ${disk} <<EOF
2048,525M,b
,${swap_size},S
,${root_size},L
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
if [ $boot == "BIOS" ]; then
    mount --mkdir ${disk1} /mnt/boot
elif [ $boot == "UEFI" ]; then
    mount --mkdir ${disk1} /mnt/boot/efi
else
    mount --mkdir ${disk1} /mnt/boot/efi
fi
mount --mkdir ${disk4} /mnt/home
#Install system
if [ $zen == "No" ]; then
    pacstrap /mnt base base-devel linux linux-firmware vim git neofetch networkmanager
elif [ $zen == "Yes" ]; then
    pacstrap /mnt base base-devel linux-zen linux-zen-headers vim git neofetch networkmanager
else
    pacstrap /mnt base base-devel linux linux-firmware vim git neofetch networkmanager
fi
#Configure system
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt <<EOF
git clone https://github.com/OfficialKouling/arch
echo ${disk2}
cd arch
EOF
arch-chroot /mnt
