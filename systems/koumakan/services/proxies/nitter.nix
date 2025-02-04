{_utils, ...}: {
  services.nginx.virtualHosts."nitter.soopy.moe" = _utils.mkVhost {
    locations."/".return = "301 https://twiiit.com$request_uri";
  };
}
