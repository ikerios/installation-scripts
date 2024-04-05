{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers = {
    valheim-one = {
      image = "ghcr.io/lloesche/valheim-server";
      autoStart = false;
      ports = [
        "0.0.0.0:2456:2456/udp"
        "0.0.0.0:2457:2457/udp"
      ];
      #user = "root:root";
      environment = {
        TZ = "Europe/Rome";
        SERVER_NAME = "firstworld";
        WORLD_NAME = "firstworld";
        SERVER_PASS = "--";
        #POST_BOOTSTRAP_HOOK = " apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y full-upgrade ";
        SERVER_PUBLIC = "false";
        ADMINLIST_IDS = "--";
        SERVER_ARGS = " -modifier raids none -modifier portals casual ";
        #SERVER_ARGS = " -modifier raids none -modifier portals casual -setkey nobuildcost ";
      };
      extraOptions = [
        "--pull=newer"
        "--cap-add=sys_nice"
      ];
      volumes = [
        "/root/podman/valheim-one/config:/config"
        "/root/podman/valheim-one/data:/opt/valheim"
      ];
    };
  };
  
  networking.firewall.allowedUDPPorts = [ 2456 2457 ];
  networking.firewall.interfaces.podman0.allowedUDPPorts = [ 2456 2457 ];
}
