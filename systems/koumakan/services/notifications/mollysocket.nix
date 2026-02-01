{ _utils, ... }:
{
  services.mollysocket = {
    enable = true;
    settings.port = 35153;
    # i don't think we need vapid stuff
  };

  services.nginx.virtualHosts."ms.soopy.moe" = _utils.mkSimpleProxy {
    port = 35153;
  };
}
