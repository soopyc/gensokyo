{
  _utils,
  config,
  pkgs,
  ...
}: {
  services.cockpit = {
    enable = true;
    settings = {
      Session = {
        Banner = builtins.toString (pkgs.writeText "cockpit-banner.txt" ''
          Welcome to Cockpit @ Koumakan.
        '');
      };

      WebService = {
        # provided with the recommended proxy settings
        ProtocolHeader = "X-Forwarded-Proto";
        ForwardedForHeader = "X-Forwarded-For";

        # customization
        LoginTitle = "Welcome to NixOS";

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
