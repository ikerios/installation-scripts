{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    adw-gtk3
    b2sum
    blackbox-terminal
    btop
    btrfs-progs
    discord
    dosfstools
    e2fsprogs
    exfatprogs
    firefox
    gimp
    gnome.gnome-tweaks
    gnomeExtensions.appindicator
    gnomeExtensions.bing-wallpaper-changer
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-dock
    gnomeExtensions.gnome-40-ui-improvements
    gnomeExtensions.gsconnect
    gnomeExtensions.just-perfection
    gnomeExtensions.no-titlebar-when-maximized
    gnomeExtensions.quick-settings-tweaker
    gnomeExtensions.tiling-assistant
    gparted
    htop
    kora-icon-theme
    libappindicator
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
