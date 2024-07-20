{
  pkgs,
  _utils,
  ...
}: {
  services.nginx.virtualHosts."_" = _utils.mkVhost {
    useACMEHost = "kita-web.c.soopy.moe";
    default = true;

    locations."/" = {
      root = pkgs.callPackage ./package.nix {};
      tryFiles = "$uri $uri/index.html $uri.html =404";
    };
  };
}
