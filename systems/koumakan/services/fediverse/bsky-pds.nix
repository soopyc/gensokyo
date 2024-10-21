{
  inputs,
  pkgs,
  _utils,
  ...
}: {
  services.bsky-pds = {
    enable = true;
    package = inputs.mystia.packages.${pkgs.system}.bsky-pds;

    # because sensible settings are already defined in the module, we can keep this simple :)
    settings.PDS_HOSTNAME = "bsky.soopy.moe";
  };

  services.nginx.virtualHosts.".bsky.soopy.moe" = _utils.mkSimpleProxy {
    port = 2583;
    websockets = true;
    extraConfig = {
      useACMEHost = "bsky.c.soopy.moe";
    };
  };
}
