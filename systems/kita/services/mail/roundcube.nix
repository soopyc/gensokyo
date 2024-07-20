{
  pkgs,
  _utils,
  ...
}: {
  services.roundcube = {
    enable = true;
    package = pkgs.roundcube.withPlugins (plugins: with plugins; [carddav contextmenu]);
    dicts = with pkgs.aspellDicts; [en];
    hostName = "webmail.soopy.moe";
  };

  services.nginx.virtualHosts."webmail.soopy.moe" = _utils.mkVhost {
    enableACME = false;
    useACMEHost = "kita-web.c.soopy.moe";
  };
}
