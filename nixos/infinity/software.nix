{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    aha
    b2sum
    btop
    btrfs-progs
    #calibre
    cifs-utils
    claude-code
    direnv
    discord
    dosfstools
    e2fsprogs
    exfatprogs
    fastfetch
    (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true;}) {})
    htop
    joplin-desktop
    krita-unwrapped
    libreoffice-fresh
    nixfmt
    nmap
    nvd
    obs-studio
    onlyoffice-desktopeditors
    pciutils
    planify
    podman-desktop
    popsicle
    protonmail-desktop
    protonvpn-gui
    proton-pass
    readest
    snapper-gui
    speechd
    sq
    sslscan
    telegram-desktop
    ungoogled-chromium
    usbutils
    vim
    vlc
    vscode
    vscodium
    wget
  ];
}
