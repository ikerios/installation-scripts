{ config, pkgs, ... }:

{
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  security.virtualisation.flushL1DataCache = "never";

  networking.firewall.trustedInterfaces = [ "virbr0" ];

  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
    };
    podman = {
      enable = true;
      #dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      networkSocket.openFirewall = true;
    };
    docker.enable = false;
  };
}
