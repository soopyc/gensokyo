{ _utils, ... }:
{
  services.nginx.virtualHosts = {
    "pub.soopy.moe" = _utils.mkVhost {
      locations."/".root = ./verification-data;
    };
  };
}
