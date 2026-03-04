{ config, pkgs, ... }:

{
  boot.initrd.kernelModules = [ "kvm-intel" "i915" "xe" ];
  #boot.initrd.kernelModules = [ "kvm-intel" "i915" ];
  #boot.kernelParams = [ "mitigations=off" "quiet" "resume_offset=533760" ];
  #boot.initrd.kernelModules = [ "kvm-intel" "xe" ];
  boot.kernelParams = [ "mitigations=off" "quiet" "resume_offset=533760" "i915.force_probe=!9a49" "xe.force_probe=9a49" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.resumeDevice = "/dev/disk/by-uuid/43fbcf00-9b24-4ecf-9448-bad998a25df5";

  boot.kernel.sysctl = {
   "vm.swappiness" = 1;
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  fileSystems."/" =
   { device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=@" "compress=zstd" "noatime" ];
   };

  fileSystems."/nix" =
   { device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=@pkg" "compress=zstd" "noatime" ];
   };

  fileSystems."/var/log" =
   { device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=@log" "compress=zstd" "noatime" ];
   };

  fileSystems."/.snapshots" =
   { device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=@.snapshots" "compress=zstd" "noatime" ];
   };

  fileSystems."/swap" =
   { device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=@swap" "compress=zstd" "noatime" ];
   };

  fileSystems."/home" =
   { device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" "noatime" ];
   };

  hardware.graphics = {
   enable = true;
   extraPackages = with pkgs; [
    intel-media-driver
    libvdpau-va-gl
    libva-vdpau-driver
    vpl-gpu-rt
   ];
  };

  # hardware.system76 = {
  #  power-daemon.enable = false;
  #  kernel-modules.enable = false;
  #  firmware-daemon.enable = false;
  #  enableAll = false;
  # };

  services.thermald.enable = true;

  services.power-profiles-daemon.enable = true;

  services.fwupd.enable = true;
}
