{ config, pkgs, ... }:

{
  #services.displayManager.sddm = {
  #  enable = true;
  #  wayland = {
  #    enable = true;
  #    #compositor = "kwin";
  #  };
  #};

  services.displayManager.plasma-login-manager.enable = true;

  services.desktopManager.plasma6.enable = true;

  programs.dconf.enable = true;

  xdg.portal = {
    extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde ];
  };

  programs.kdeconnect.enable = true;
  services.geoclue2.enable = true;

  environment.systemPackages = with pkgs; [ kdePackages.kcalc kdePackages.calligra ];

  services.desktopManager.plasma6.enableQt5Integration = false;
}
