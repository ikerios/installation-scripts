#!/bin/bash

if [ "$1" == "" ]; then
    echo "Missing device (e.g. /dev/nvme0n1)"
    exit 1
fi

if [ "$2" == "" ]; then
    echo "Missing distro (e.g. arch, nixos, ... )"
    exit 1
fi

if [[ "$2" != "arch" ]] && [[ "$2" != "nixos" ]]; then
    echo "Accepted values: arch, nixos"
    exit 1
fi


DEVICE_DISK=$1
DISTRO=$2

## partitioning, formatting and mounting
parted -s "$DEVICE_DISK" mklabel gpt mkpart ESP fat32 1MiB 1GiB set 1 boot on mkpart "root" 1GiB 100%

# quirk to handle nvme naming
if [[ "$DEVICE_DISK" == *"nvme"* ]]; then
  DEVICE_DISK+="p"
fi

# root partition
cryptsetup luksFormat -y -v "${DEVICE_DISK}"2
cryptsetup open "${DEVICE_DISK}"2 root
mkfs.btrfs /dev/mapper/root
mount /dev/mapper/root /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@log
btrfs su cr /mnt/@swap

# generic for package storage
btrfs su cr /mnt/@pkg

umount /mnt
mount -o noatime,subvol=@ /dev/mapper/root /mnt
mkdir -p /mnt/{efi,home,.snapshots,var/log,swap}
mount -o noatime,subvol=@home /dev/mapper/root /mnt/home
mount -o noatime,compress=zstd,subvol=@.snapshots /dev/mapper/root /mnt/.snapshots
mount -o noatime,compress=zstd,subvol=@log /dev/mapper/root /mnt/var/log
mount -o noatime,subvol=@swap /dev/mapper/root /mnt/swap

if [[ ${DISTRO} == "arch" ]]; then
    mkdir -p /mnt/var/cache/pacman/pkg
    mount -o noatime,compress=zstd,subvol=@pkg /dev/mapper/root /mnt/var/cache/pacman/pkg
fi

if [[ ${DISTRO} == "nixos" ]]; then
    mkdir -p /mnt/nix
    mount -o noatime,compress=zstd,subvol=@pkg /dev/mapper/root /mnt/nix
fi

# create swap file inside the swap subvolume
btrfs filesystem mkswapfile --size 32g --uuid clear /mnt/swap/swapfile
swapon /mnt/swap/swapfile

# ESP partition
mkfs.fat -F32 "${DEVICE_DISK}"1
mount "${DEVICE_DISK}"1 /mnt/efi
