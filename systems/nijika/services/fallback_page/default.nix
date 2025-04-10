{
  pkgs,
  _utils,
  ...
}:
{
  services.nginx.virtualHosts."nijika.soopy.moe" = _utils.mkVhost {
    useACMEHost = null;
    enableACME = true;
    default = true;

    locations."/" = {
      root = pkgs.callPackage ./package.nix { };
      tryFiles = "$uri $uri/index.html $uri.html =404";
    };
  };
}
