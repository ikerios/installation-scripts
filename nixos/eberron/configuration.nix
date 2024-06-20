{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.kernelParams = [ "mitigations=off" ];
  boot.swraid.enable = true;
  boot.swraid.mdadmConf = "MAILADDR --@--.--";

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";

  networking.hostName = "eberron";
  networking.networkmanager.enable = true;
  networking.nftables.enable = true;

  time.timeZone = "Europe/Rome";

  i18n.defaultLocale = "C.UTF-8";

  console = {
    keyMap = "it";
  };

  users.users.-- = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirt" "podman" ];
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [ ];
  };

  #users.users.root.openssh.authorizedKeys.keys = [""];

  environment.systemPackages = with pkgs; [ btop htop duf pciutils smartmontools ];

  services.openssh = {
    enable = true;
    #settings.PermitRootLogin = "yes"
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    openFirewall = true;
  };

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  # networking.firewall.allowedTCPPorts = [];
  # networking.firewall.allowedUDPPorts = [];

  system.stateVersion = "24.05";
}
