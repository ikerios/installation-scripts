{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers = {
    enshrouded-one = {
      image = "docker.io/sknnr/enshrouded-dedicated-server:proton-latest";
      autoStart = false;
      ports = [
        "0.0.0.0:15636:15636/udp"
        "0.0.0.0:15637:15637/udp"
      ];
      environment = {
        SERVER_NAME = "--";
        SERVER_SLOTS = "2";
        SERVER_PASSWORD = "--";
        GAME_PORT = "15636";
        QUERY_PORT = "15637";
        SERVER_IP = "127.0.0.1";
      };
      extraOptions = [
        "--pull=newer"
        "--cap-add=sys_nice"
      ];
      volumes = [
        "/storage/podman/enshrouded-one/download:/home/steam/enshrouded"
        "/storage/podman/enshrouded-one/data:/home/steam/enshrouded/savegame"
      ];
    };
  };

  networking.firewall.allowedUDPPorts = [ 15636 15637 ];
  networking.firewall.interfaces.podman0.allowedUDPPorts = [ 15636 15637 ];
}
