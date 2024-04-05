# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./infinity.nix
      ./plymouth.nix
      ./desktop.nix
      ./virtualization.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # Set your time zone.
  time.timeZone = "Europe/Rome";

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
    virt-manager
    vlc
    vscodium
    wget
  ];
  

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.openFirewall = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  #networking.firewall.enable = false;

  system.stateVersion = "23.11";

}
