# sandbox deployment of a bsky pds
{
  pkgs,
  inputs,
  _utils,
  config,
  ...
}: {
  services.bsky-pds = {
    enable = true;
    package = inputs.mystia.packages.${pkgs.system}.bsky-pds;

    settings.PDS_HOSTNAME = "amia.sandbox.soopy.moe";
  };

  services.nginx.virtualHosts.".amia.sandbox.soopy.moe" = _utils.mkSimpleProxy {
    port = config.services.bsky-pds.settings.PDS_PORT;
    # websockets = true;
    extraConfig = {
      useACMEHost = "amia-sandbox.c.soopy.moe";
    };
  };
}
