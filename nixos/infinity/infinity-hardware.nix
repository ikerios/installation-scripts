{ config, pkgs, ... }:

let
  #define here uuid found in hardware-configuration.nix
  disk_uuid = "";
in

{
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "rtsx_pci_sdmmc" "crc32c_intel" "aesni_intel" ];
  boot.initrd.kernelModules = [ "kvm-intel" "i915" ];
  boot.kernelParams = [ "mitigations=off" "quiet" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/" + disk_uuid;
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "noatime" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/" + disk_uuid;
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" "noatime" ];
    };

  fileSystems."/.snapshots" =
    {
      device = "/dev/disk/by-uuid/" + disk_uuid;
      fsType = "btrfs";
      options = [ "subvol=@snapshots" "compress=zstd" "noatime" ];
    };

  fileSystems."/var/log" =
    {
      device = "/dev/disk/by-uuid/" + disk_uuid;
      fsType = "btrfs";
      options = [ "subvol=@log" "compress=zstd" "noatime" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/" + disk_uuid;
      fsType = "btrfs";
      options = [ "subvol=@pkg" "compress=zstd" "noatime" ];
    };

  swapDevices = [{ device = "/swap/swapfile"; }];

}
