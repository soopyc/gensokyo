{
  inputs,
  pkgs,
  _utils,
  ...
}: {
  services.bsky-pds = {
    enable = true;
    package = inputs.mystia.packages.${pkgs.system}.bsky-pds;
    settings.PDS_HOSTNAME = "bsky.soopy.moe";
  };

  services.nginx.virtualHosts.".bsky.soopy.moe" = _utils.mkSimpleProxy {
    port = 2583;
    extraConfig = {
      useACMEHost = "bsky.c.soopy.moe";
    };
  };
}
