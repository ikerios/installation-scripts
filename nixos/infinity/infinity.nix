{ config, pkgs, ... }:

{
  boot.initrd.kernelModules = [ "kvm-intel" "i915" ];
  boot.kernelParams = [ "mitigations=off" "quiet" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  swapDevices = [{ device = "/swap/swapfile"; }];

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiVdpau
      libvdpau-va-gl
    ];
    driSupport32Bit = true;
  };

  hardware.system76 = {
    #enableAll = true;
    firmware-daemon.enable = true;
    #kernel-modules.enable = false;
    #power-daemon.enable = true;
  };

  services.thermald.enable = true;

  services.power-profiles-daemon.enable = true;

  #services.auto-cpufreq.enable = true;
  #services.system76-scheduler.enable = true;

  #enable tpm for encryption disks
  security.tpm2.enable = true;
}
