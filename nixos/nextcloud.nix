{ config, pkgs, ... }:

{
  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  services.postgresql = {
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
    ];
  };

  environment.etc."nextcloud-admin-pass".text = "--";
  services.nextcloud =
    {
      enable = true;
      hostName = "--";
      #package = pkgs.nextcloud27;
      config = {
        dbtype = "pgsql";
        adminpassFile = "/etc/nextcloud-admin-pass";
      };
      https = true;
      configureRedis = true;
      maxUploadSize = "2G";
      extraOptions.enabledPreviewProviders = [
        "OC\\Preview\\BMP"
        "OC\\Preview\\GIF"
        "OC\\Preview\\JPEG"
        "OC\\Preview\\Krita"
        "OC\\Preview\\MarkDown"
        "OC\\Preview\\MP3"
        "OC\\Preview\\OpenDocument"
        "OC\\Preview\\PNG"
        "OC\\Preview\\TXT"
        "OC\\Preview\\XBitmap"
        "OC\\Preview\\HEIC"
      ];
      extraAppsEnable = true;
    };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "--";

  networking.firewall.allowedTCPPorts = [ 80 443 3478 ];
  networking.firewall.allowedUDPPorts = [ 80 443 3478 ];
}
