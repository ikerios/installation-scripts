{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers = {
    vrising-dorcopio = {
      image = "docker.io/sknnr/vrising-dedicated-server";
      autoStart = true;
      ports = [
        "9876:9876/udp"
        "9877:9877/udp"
        "27015:27015/udp"
        "27016:27016/udp"
      ];
      environment = {
        SERVER_NAME = "";
        SERVER_PASSWORD = "";
        GAME_PORT = "27015";
        QUERY_PORT = "27016";
        DESCRIPTION = "";
        BIND_ADDRESS = "0.0.0.0";
        HIDE_IP = "true";
        LOWER_FPS_EMPTY = "true";
        SECURE = "true";
        EOS_LIST = "true";
        STEAM_LIST = "false";
        GAME_PRESET = "StandardPvE";
        DIFFICULTY = "Difficulty_Normal";
        SAVE_NAME = "";
      };
      extraOptions = [
        "--pull=newer"
        "--cap-add=sys_nice"
      ];
      volumes = [
        "/storage/podman/vrising-one/data:/opt/steam/vrising/save-data"
      ];
    };
  };

  networking.firewall.allowedUDPPorts = [ 9876 9877 27015 27016 ];
  networking.firewall.interfaces.podman0.allowedUDPPorts = [ 9876 9877 27015 27016 ];
}
