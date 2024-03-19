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
gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	"Write a PC name (ex. server)"
pc_name=$(gum input --placeholder "PC name")
clear
gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	"Write a root password (ex. 1234)"
root_password=$(gum input --password --placeholder "root password")
clear
gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	"Write a username (ex. giovanni_giorgio)"
username=$(gum input --placeholder "username")
clear
gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	"Write a password for username (ex. qwerty)"
username_password=$(gum input --password --placeholder "${username} password")
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
cd arch
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "${pc_name}" > /etc/hostname
echo "127.0.0.1	localhost" > /etc/hosts
echo "::1	     localhost" >> /etc/hosts
echo "127.0.0.1	${pc_name}.localdomain	${pc_name}"
systemctl enable NetworkManager
chpasswd <<<"root:${root_password}"
useradd ${username}
chpasswd <<<"${username}:${username_password}"
usermod -aG wheel ${username}
mkdir /home/${username}
chown ${username}:${username} /home/${username}
git clone https://github.com/OfficialKouling/arch /home/${username}/.shit_from_git
pacman -Sy grub efibootmgr sudo --noconfirm
echo "%sudo	ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
if [ $boot == "BIOS" ]; then
    grub-install --target=i386-pc /dev/sda
elif [ $boot == "UEFI" ]; then
    grub-install --target=x86_64-efi --efi-directory=/boot/efi
    grub-mkconfig -o /boot/grub/grub.cfg
    mkdir /boot/efi/EFI/boot
    cp /boot/efi/EFI/arch/grubx64.efi /boot/efi/EFI/boot/bootx64.efi
else
    echo "errr3r1oro1r46@!3ororor21415o12ro1213rorrrr"
fi
mv /arch /home/${username}
chown ${username}:${username} -R /home/${username}/arch
EOF
arch-chroot /mnt
