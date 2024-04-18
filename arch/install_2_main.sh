#!/bin/bash

if [ "$1" == "" ]; then
    echo "Missing device (e.g. /dev/nvme0n1)"
    exit 1
fi

if [ "$2" == "" ]; then
    echo "Missing hostoname"
    exit 1
fi

if [ "$3" == "" ]; then
    echo "Missing sudoers user (e.g. Sara)"
    exit 1
fi

if [ "$4" == "" ]; then
    echo "Missing password for sudoers user (and root)"
    exit 1
fi

DEVICE_DISK=$1
INST_HOSTNAME=$2
INST_USER=$3
INST_PWD=$4

# quirk to handle nvme naming
if [[ "$DEVICE_DISK" == *"nvme"* ]]; then
  DEVICE_DISK+="p"
fi


ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
hwclock --systohc
sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen
#sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
echo "FONT=ter-122b" >> /etc/vconsole.conf
echo "FONT_MAP=8859-2" >> /etc/vconsole.conf
echo $INST_HOSTNAME > /etc/hostname
echo root:$INST_PWD | chpasswd

pacman -Syy --noconfirm --needed bash-completion sudo openssh efibootmgr terminus-font networkmanager iwd btrfs-progs dosfstools exfatprogs e2fsprogs xfsprogs

# if using reflector
# pacman -Sy --noconfirm --needed reflector
# reflector -c Italy -a 4 --save /etc/pacman.d/mirrorlist

# install sytstemd-boot
bootctl install

useradd -m $INST_USER
echo $INST_USER:$INST_PWD | chpasswd

echo "$INST_USER ALL=(ALL) ALL" >> /etc/sudoers.d/$INST_USER

ROOT_UUID=$(blkid -s UUID -o value "${DEVICE_DISK}"2)

#crypt parameters and resume support for grub
CMD_LINE_CRYPT="rd.luks.name=$ROOT_UUID=root root=/dev/mapper/root resume=/dev/mapper/root rd.luks.options=$ROOT_UUID=tpm2-device=auto"
CMD_LINE_GENERIC="rootflags=subvol=@ rootfstype=btrfs rw quiet mitigations=off"

CMD_LINE="${CMD_LINE_CRYPT} ${CMD_LINE_GENERIC}"

#echo $CMD_LINE
echo $CMD_LINE >> /etc/kernel/cmdline

sed -i 's/^default_image/#&/' /etc/mkinitcpio.d/linux.preset
sed -i 's/^fallback_image/#&/' /etc/mkinitcpio.d/linux.preset
sed -i 's/^#default_uki/default_uki/' /etc/mkinitcpio.d/linux.preset
sed -i 's/^#fallback_uki/fallback_uki/' /etc/mkinitcpio.d/linux.preset

#enable crypt support in mkinitcpio
# MKINITCPIO_MODULES="MODULES=(btrfs)"
# MKINITCPIO_BINARIES="BINARIES=(/usr/bin/btrfs)"
MKINITCPIO_HOOKS="HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt filesystems fsck)"

sed -i "/^MODULES=/c$MKINITCPIO_MODULES" /etc/mkinitcpio.conf
sed -i "/^BINARIES=/c$MKINITCPIO_BINARIES" /etc/mkinitcpio.conf
sed -i "/^HOOKS=/c$MKINITCPIO_HOOKS" /etc/mkinitcpio.conf

mkinitcpio -P

systemctl enable NetworkManager
systemctl enable sshd


/bin/echo -e "\e[1;32mDone! Type exit, umount -R /mnt and reboot.\e[0m"
