#!/bin/bash
trap exit_user INT
exit_user() {
    echo "exiting.." ; exit 1
}
banner () {
    gum style \
        --foreground 212 --border-foreground 212 --border double \
        --align center --width 50 --margin "1 2" --padding "2 4" \
        "$_text"
}

pacman -S gum --noconfirm ; clear
_text='Do you have BIOS or UEFI?' && banner
boot="$(gum choose --limit 1 BIOS UEFI)" ; clear
lsblk | awk '{print $1, $4}'
_text='Which is your disk? (ex. /dev/sda)' && banner
disk="$(gum choose --limit 1 /dev/sda /dev/sdb /dev/sdd /dev/nvme0n1p)" ; clear
_text='Give me size of SWAP partition' && banner
swap_size="$(gum choose --limit 1 8192M 4096M 2048M 1024M)" ; clear
_text='Do you want to make a home partition?' && banner
make_root="$(gum choose --limit 1 Yes No)" ; clear
if [ $make_root == "Yes" ]; then
    _text='Give me size of root partition' && banner
    root_size="$(gum choose --limit 1 61440M 40960M 20480M 10240M)" ; clear
fi
_text='Do you want to install linux-zen?' && banner
zen="$(gum choose --limit 1 Yes No)" ; clear
_text='Write a PC name (ex. server)' && banner
pc_name=$(gum input --placeholder "PC name") ; clear
_text='Write a root password (ex. 1234)' && banner
root_password=$(gum input --password --placeholder "root password") ; clear
_text='Write a username (ex. giovanni_giorgio)' && banner
username=$(gum input --placeholder "username") ; clear
_text='Write a password for username (ex. qwerty)' && banner
username_password=$(gum input --password --placeholder "${username} password") ; clear
#Disk partitioning
if [ $make_root == "Yes" ]; then
    sfdisk ${disk} <<EOF
2048,525M,b
,${swap_size},S
,${root_size},L
;
EOF
elif [ $make_root == "No" ]; then
    sfdisk ${disk} <<EOF
2048,525M,b
,${swap_size},S
;
EOF
fi
#Create File System
mkfs.fat -F 32 ${disk}1 &&
mkswap ${disk}2 &&
mkfs.ext4 ${disk}3 &&
mkfs.ext4 ${disk}4 &&
#Mount disks
swapon ${disk}2
mount --mkdir ${disk}3 /mnt
if [ $boot == "BIOS" ]; then
    mount --mkdir ${disk}1 /mnt/boot
elif [ $boot == "UEFI" ]; then
    mount --mkdir ${disk}1 /mnt/boot/efi
fi
mount --mkdir ${disk}4 /mnt/home
#Install system
if [ $zen == "No" ]; then
    pacstrap /mnt base base-devel linux linux-firmware vim git neofetch networkmanager
elif [ $zen == "Yes" ]; then
    pacstrap /mnt base base-devel linux-zen linux-zen-headers vim git neofetch networkmanager
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
chpasswd <<<"root:${root_password}" ; clear
useradd ${username}
chpasswd <<<"${username}:${username_password}" ; clear
usermod -aG wheel ${username}
mkdir /home/${username}
chown ${username}:${username} /home/${username}
#git clone https://github.com/OfficialKouling/arch /home/${username}/.shit_from_git
pacman -Sy grub efibootmgr sudo --noconfirm
echo "%sudo  ALL=(ALL:ALL) ALL" >> /etc/sudoers
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
