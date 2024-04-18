#!/bin/bash

if [ "$1" == "" ]; then
    echo "Missing partition (e.g. /dev/nvme0n1p2)"
    exit 1
fi

PARTITION=$1

cryptsetup luksFormat -y -v "${PARTITION}"2

systemd-cryptenroll "${PARTITION}" --wipe-slot=tpm2
systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+1+7 "${PARTITION}"
