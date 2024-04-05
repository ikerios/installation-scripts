{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers = {
    pihole = {
      image = "pihole/pihole:latest";
      autoStart = true;
      ports = [
        "0.0.0.0:53:53"
        "0.0.0.0:80:80"
      ];
      environment = {
        TZ = "Europe/Rome";
        VIRTUAL_HOST = "pi.hole";
        PROXY_LOCATION = "pi.hole";
        FTLCONF_LOCAL_IPV4 = "--";
      };
      extraOptions = [
        "--pull=newer"
        "--cap-add=sys_nice"
      ];
      volumes = [
        "/root/podman/pihole/etc-pihole:/etc/pihole"
        "/root/podman/pihole/etc-dnsmasq.d:/etc/dnsmasq.d"
      ];
    };
  };
}
