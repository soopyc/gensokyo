{_utils, config, ...}: {
  services.cockpit = {
    enable = true;
    settings = {
      Session = {
        Banner = "/etc/motd.custom";
      };

      WebService = {
        # provided with the recommended proxy settings
        ProtocolHeader = "X-Forwarded-Proto";
        ForwardedForHeader = "X-Forwarded-For";

        # hardening
        AllowUnencrypted = false;
        MaxStartups = "5:50:20";
        LoginTo = false;
      };

      # OAuth = {};
    };
  };

  services.nginx.virtualHosts."reimu.soopy.moe" = _utils.mkSimpleProxy {
    port = config.services.cockpit.port;
    protocol = "https";
    websockets = true;
  };
}
