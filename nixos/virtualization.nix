{ config, pkgs, ... }:
{

  # Virtualization
  programs.dconf.enable = true;
  security.virtualisation.flushL1DataCache = "never";

  virtualisation = {
    libvirtd = {
      enable = true;
    };
    # docker = {
    #   enable = true;
    #   storageDriver = "btrfs";
    # };
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      networkSocket.openFirewall = true;
    };
  };

  virtualisation.containers.storage.settings =
    {
      storage = {
        driver = "btrfs";
        graphroot = "/var/lib/containers/storage";
        runroot = "/run/containers/storage";
      };
    };


  virtualisation.cri-o.storageDriver = "btrfs";
}
