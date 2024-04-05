#!/bin/bash

# default values
INST_USER=xon
INST_PWD=password

ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
hwclock --systohc
sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen
#sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
echo "FONT=ter-122b" >> /etc/vconsole.conf
echo "FONT_MAP=8859-2" >> /etc/vconsole.conf
echo "infinity" > /etc/hostname
echo root:$INST_PWD | chpasswd

pacman -Syy --noconfirm --needed base-devel bash-completion openssh grub efibootmgr reflector terminus-font networkmanager dosfstools btrfs-progs e2fsprogs tpm2-tss

reflector -c Italy -a 4 --save /etc/pacman.d/mirrorlist

systemctl enable NetworkManager
systemctl enable sshd
#systemctl enable fstrim.timer

useradd -m $INST_USER
echo $INST_USER:$INST_PWD | chpasswd

echo "$INST_USER ALL=(ALL) ALL" >> /etc/sudoers.d/$INST_USER

#BOOT_UUID=$(blkid -s UUID -o value /dev/nvme0n1p1)
SWAP_UUID=$(blkid -s UUID -o value /dev/nvme0n1p2)
ROOT_UUID=$(blkid -s UUID -o value /dev/nvme0n1p3)

#enable crypt support for grub
sed -i '/^#GRUB_ENABLE_CRYPTODISK/s/.//' /etc/default/grub

#crypt parameters and resume support for grub
GRUB_LINE_CRYPT=GRUB_CMDLINE_LINUX=\""rd.luks.name=$ROOT_UUID=cryptroot rd.luks.name=$SWAP_UUID=cryptswap root=/dev/mapper/cryptroot resume=/dev/mapper/cryptswap rd.luks.options=$ROOT_UUID=tpm2-device=auto rd.luks.options=$SWAP_UUID=tpm2-device=auto \""

#/dev/tpmrm0

#echo $GRUB_LINE_CRYPT
sed -i "/^GRUB_CMDLINE_LINUX=/c$GRUB_LINE_CRYPT" /etc/default/grub

#enable crypt support in mkinitcpio
MKINITCPIO_MODULES="MODULES=(i915)"
MKINITCPIO_BINARIES="BINARIES=(btrfs nano)"
MKINITCPIO_HOOKS="HOOKS=(base systemd autodetect keyboard sd-vconsole modconf block sd-encrypt filesystems fsck)"

#echo $MKINITCPIO_MODULES
#echo $MKINITCPIO_BINARIES
#echo $MKINITCPIO_HOOKS

sed -i "/^MODULES=/c$MKINITCPIO_MODULES" /etc/mkinitcpio.conf
sed -i "/^BINARIES=/c$MKINITCPIO_BINARIES" /etc/mkinitcpio.conf
sed -i "/^HOOKS=/c$MKINITCPIO_HOOKS" /etc/mkinitcpio.conf

echo "cryptroot	/dev/nvme0n1p3	-	tpm2-device=auto" >> /etc/crypttab.initramfs
echo "cryptswap	/dev/nvme0n1p2	-	tpm2-device=auto" >> /etc/crypttab.initramfs

systemd-cryptenroll /dev/nvme0n1p2 --wipe-slot=tpm2
systemd-cryptenroll /dev/nvme0n1p3 --wipe-slot=tpm2

systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+1+7 /dev/nvme0n1p2
systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+1+7 /dev/nvme0n1p3

mkinitcpio -P

grub-install --removable --recheck --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH
grub-mkconfig -o /boot/grub/grub.cfg

/bin/echo -e "\e[1;32mDone! Type exit, umount -R /mnt and reboot.\e[0m"
