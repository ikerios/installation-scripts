# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repository contains automated installation and configuration scripts for Arch Linux and NixOS, with a focus on:
- Full-disk LUKS2 encryption with Btrfs subvolumes
- TPM2-backed automatic disk unlock
- Modular NixOS configurations for desktops and self-hosted services

## Repository Structure

```
.
├── partitioning.sh         # Disk partitioning, LUKS encryption, Btrfs setup
├── recovery_remount.sh     # Re-mounts encrypted volumes (for recovery)
├── tpm_enroll.sh           # Enrolls TPM2 for automatic LUKS unlock
├── arch/
│   ├── install_1_base.sh   # Pacstrap + fstab generation
│   └── install_2_main.sh   # Full Arch system config (locale, user, bootloader)
└── nixos/
    ├── desktop.nix         # Shared desktop base (locale, audio, fonts, Flatpak)
    ├── gnome.nix           # GNOME + extensions (imports desktop.nix)
    ├── kde.nix             # KDE Plasma 6 (imports desktop.nix)
    ├── plymouth.nix        # Boot splash
    ├── virtualization.nix  # libvirtd + Podman
    ├── nextcloud.nix       # Nextcloud 29 + PostgreSQL + Redis + ACME
    ├── pihole.nix          # Pi-hole DNS container
    ├── valheim.nix         # Valheim game server container
    ├── vrising.nix         # V Rising game server container
    ├── enshrouded.nix      # Enshrouded game server container
    ├── eberron/            # Host config: server with RAID + auto-upgrade
    └── infinity/           # Host config: desktop with Intel + System76 firmware
```

## Key Conventions

### Btrfs Subvolume Layout
All installations use the same subvolume layout:
- `@` → `/`
- `@home` → `/home`
- `@.snapshots` → `/.snapshots`
- `@log` → `/var/log`
- `@swap` → `/swap`
- `@pkg` → `/var/cache/pacman/pkg` (Arch) or `/nix` (NixOS)

### NixOS Module Pattern
- `gnome.nix` and `kde.nix` both `import ./desktop.nix` — avoid duplicating desktop base config
- Container services (game servers, pihole) use Podman with volumes at `/storage/podman/<service>/`
- Host-specific configs live under `nixos/<hostname>/` with a main `configuration.nix`

### Arch Installation Sequence
```bash
# 1. Partition disk
./partitioning.sh /dev/nvme0n1 arch

# 2. Chroot and bootstrap
arch-chroot /mnt /path/to/arch/install_1_base.sh

# 3. Configure system
arch-chroot /mnt /path/to/arch/install_2_main.sh /dev/nvme0n1 <hostname> <user> <password>

# 4. (Optional) TPM2 enrollment after first boot
./tpm_enroll.sh /dev/nvme0n1p2
```

### NixOS Installation Sequence
```bash
# 1. Partition disk
./partitioning.sh /dev/nvme0n1 nixos

# 2. Copy nixos/ configs to /mnt/etc/nixos/, then
nixos-install

# Recovery: remount encrypted volumes
./recovery_remount.sh /dev/nvme0n1 nixos
```

## Hardware Defaults (Arch)
- Locale: `it_IT.UTF-8` / `en_US.UTF-8`, timezone: `Europe/Rome`
- Keyboard: US console, IT X11 layout
- Bootloader: `systemd-boot` with UKI and TPM2 (`rd.luks.options=tpm2-device=auto`)
- mkinitcpio hooks: `systemd btrfs sd-vconsole sd-encrypt`

## NixOS Service Notes
- `nextcloud.nix`: Uses Let's Encrypt — set `security.acme.certs` and `nextcloud.hostName` before deploying
- Game server containers expose UDP ports; firewall rules are included in each `.nix` file
- `virtualization.nix`: Uses Podman (not Docker); enables `libvirtd` with `qemu:///system`
