#!/bin/bash

if [ "$1" == "" ]; then
    echo "Missing device (e.g. /dev/nvme0n1)"
    exit 1
fi

if [ "$2" == "" ]; then
    echo "Missing distro (e.g. arch, nixos, ... )"
    exit 1
fi

DEVICE_DISK=$1
DISTRO=$2

# quirk to handle nvme naming
if [[ "$DEVICE_DISK" == *"nvme"* ]]; then
  DEVICE_DISK+="p"
fi

cryptsetup open ${DEVICE_DISK}"2 root
mount -o noatime,subvol=@ /dev/mapper/root /mnt
mount -o noatime,subvol=@home /dev/mapper/root /mnt/home
mount -o noatime,compress=zstd,subvol=@.snapshots /dev/mapper/root /mnt/.snapshots
mount -o noatime,compress=zstd,subvol=@log /dev/mapper/root /mnt/var/log
mount -o noatime,subvol=@swap /dev/mapper/root /mnt/swap

if [[ ${DISTRO} == "arch" ]]; then
    mount -o noatime,compress=zstd,subvol=@pkg /dev/mapper/root /mnt/var/cache/pacman/pkg
fi

if [[ ${DISTRO} == "nixos" ]]; then
    mount -o noatime,compress=zstd,subvol=@pkg /dev/mapper/root /mnt/nix
fi

mount ${DEVICE_DISK}"1 /mnt/efi

swapon /mnt/swap/swapfile