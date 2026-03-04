{ config, lib, pkgs, ... }:

{
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
  };


  fonts.enableDefaultPackages = true;

  fonts.packages = with pkgs; [ inter source-sans source-serif source-code-pro andika charis gentium carlito caladea texlivePackages.xcharter ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  fonts.fontconfig.defaultFonts.serif = [
    "Source Serif"
  ];

  fonts.fontconfig.defaultFonts.sansSerif = [
    "Source Sans"
  ];

  fonts.fontconfig.defaultFonts.monospace = [
    "Source Code Pro"
  ];

  fonts.fontconfig.allowBitmaps = false;

  fonts.fontconfig.cache32Bit = true;

  fonts.fontconfig.subpixel.rgba = "vrgb";
  fonts.fontconfig.subpixel.lcdfilter = "light";

  fonts.fontconfig.hinting.style = "slight";

  fonts.fontDir.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ hplipWithPlugin ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    reflector = true;
    openFirewall = true;
  };

  # Enable pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ikerios = {
    isNormalUser = true;
    description = "Stefano P.";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "podman"
      "docker"
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

  programs.zsh.enable = true;
  programs.zsh.ohMyZsh.enable = true;
  programs.zsh.ohMyZsh.theme = "gentoo";
  programs.zsh.autosuggestions.enable = true;

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  programs.vscode.enable = true;
  programs.nix-ld.enable = true;

  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };

  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };
}
