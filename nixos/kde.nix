{ config, pkgs, ... }:

{

  services.xserver.displayManager.sddm =
    {
      enable = true;
      wayland.enable = true;
    };

  services.xserver.desktopManager.plasma6.enable = true;

  programs.dconf.enable = true;

  xdg.portal = {
    extraPortals = with pkgs; [ xdg-desktop-portal-kde ];
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
  ];

}
