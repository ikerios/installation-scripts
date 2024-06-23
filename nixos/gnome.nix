{ config, pkgs, ... }:

{
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];


  #environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gnome-remote-desktop.enable = true;
  services.gnome.sushi.enable = true;


  xdg.portal = {
    extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
  };

  services.gnome = {
    gnome-online-accounts.enable = true;
    gnome-user-share.enable = true;
    gnome-browser-connector.enable = true;
    gnome-settings-daemon.enable = true;
  };


  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    adw-gtk3
    blackbox-terminal
    gimp
    gnome.gnome-tweaks
    gnomeExtensions.appindicator
    gnomeExtensions.bing-wallpaper-changer
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-dock
    gnomeExtensions.dash-to-panel
    gnomeExtensions.gnome-40-ui-improvements
    gnomeExtensions.gsconnect
    gnomeExtensions.just-perfection
    gnomeExtensions.no-titlebar-when-maximized
    gnomeExtensions.tiling-assistant
    gparted
    kora-icon-theme
    libappindicator
  ];

}
