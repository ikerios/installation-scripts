{ config, pkgs, ... }:

{
  imports =
    [
      # custom infinity hardware setup
      ./infinity-hardware.nix

      # custom infinity config
      ./infinity-config.nix
    ];

}