#!/bin/bash

cryptsetup open /dev/nvme0n1p3 cryptroot
mount -o noatime,compress=zstd,subvol=@ /dev/mapper/cryptroot /mnt
mount -o noatime,compress=zstd,subvol=@home /dev/mapper/cryptroot /mnt/home
mount -o noatime,compress=zstd,subvol=@snapshots /dev/mapper/cryptroot /mnt/.snapshots
mount -o noatime,compress=zstd,subvol=@var_log /dev/mapper/cryptroot /mnt/var/log
mount /dev/nvme0n1p1 /mnt/boot

cryptsetup open /dev/nvme0n1p2 cryptswap
swapon /dev/mapper/cryptswap