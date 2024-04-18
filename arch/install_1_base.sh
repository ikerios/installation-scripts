#!/bin/bash

## base install
pacstrap -K /mnt base linux linux-firmware intel-ucode nano git 

genfstab -U /mnt >> /mnt/etc/fstab
