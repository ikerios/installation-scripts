{ config, pkgs, ... }:

let
  #define here uuid found in hardware-configuration.nix
  disk_uuid = "";
in

{
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
}
