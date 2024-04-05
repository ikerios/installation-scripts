{ config, pkgs, ... }:

{
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  console = {
    packages = with pkgs; [ terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    useXkbConfig = true; # use xkbOptions in tty.
    #keyMap = "us";
    #earlySetup = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    source-code-pro
  ];

  fonts.fontconfig.allowBitmaps = false;
  #fonts.fontconfig.cache32Bit = true;
  #fonts.fontconfig.subpixel.lcdfilter = "none";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ hplip ];

  services.avahi = {
    # Enables mDNS with .local domain support
    enable = true;
    nssmdns = true;
    reflector = true;
    openFirewall = true;
    #browseDomains = [ ];
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    #alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
  };

  #environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gnome-remote-desktop.enable = true;
  services.gnome.sushi.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.<user> = {
    isNormalUser = true;
    description = "user";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "podman"
    ];
    # packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.git = {
    enable = true;
  };

  programs.gnupg.agent.enable = true;

  services.gnome = {
    gnome-online-accounts.enable = true;
    gnome-user-share.enable = true;
    gnome-browser-connector.enable = true;
    gnome-settings-daemon.enable = true;
  };

  programs.zsh.enable = true;
  programs.zsh.ohMyZsh.enable = true;
  programs.zsh.ohMyZsh.theme = "gentoo";
  programs.zsh.autosuggestions.enable = true;

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
  };

  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #   dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  # };

}
