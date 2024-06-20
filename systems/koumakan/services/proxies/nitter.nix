{
  _utils,
  inputs,
  pkgs,
  ...
}: {
  services.nitterStable = {
    enable = true;
    redisCreateLocally = false;
    server = {
      title = "NSM";
      port = 36325;
      https = true;
      hostname = "nitter.soopy.moe";
      address = "127.0.0.1";
    };
    package = inputs.mystia.packages.${pkgs.system}.nitterStable;
  };

  services.nginx.virtualHosts."nitter.soopy.moe" = _utils.mkSimpleProxy {
    port = 36325;
  };
}
