{
  pkgs,
  _utils,
  ...
}: {
  services.nginx.virtualHosts."_" = _utils.mkVhost {
    useACMEHost = "bocchi.c.soopy.moe";
    default = true;

    locations."/" = {
      root = pkgs.callPackage ./package.nix {};
      tryFiles = "$uri $uri/index.html $uri.html =404";
    };
  };
}
