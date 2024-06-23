{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    b2sum
    btop
    btrfs-progs
    direnv
    discord
    dosfstools
    e2fsprogs
    exfatprogs
    firefox
    htop
    libreoffice-fresh
    neofetch
    nixpkgs-fmt
    nmap
    nvd
    obs-studio
    onlyoffice-bin
    pciutils
    podman-desktop
    popsicle
    protonmail-bridge
    protonmail-desktop
    protonvpn-gui
    snapper-gui
    speechd
    spotify
    sq
    telegram-desktop
    thunderbird
    usbutils
    vim
    vlc
    vscodium
    wget
  ];
}
