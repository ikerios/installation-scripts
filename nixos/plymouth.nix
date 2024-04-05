{ config, pkgs, ... }:
{
  boot.loader.timeout = 0;
  boot.initrd.systemd.enable = true;
  boot.initrd.verbose = false;
  boot.plymouth.enable = true;
  boot.consoleLogLevel = 0;
}
