{
  _utils,
  config,
  lib,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    namespace = "pixivfe";
    secrets = [ "token" ];
  };
in
{
  imports = [
    secrets.generate
    (secrets.mkTemplate "pixivfe.env" ''
      PIXIVFE_TOKEN=${secrets.placeholder "token"}
    '')
  ];

  virtualisation.arion.projects.pixivfe.settings = {
    services.pixivfe.service = {
      image = "vnpower/pixivfe:latest";
      ports = [
        "127.0.0.1:35284:8282"
      ];
      capabilities = {
        ALL = false; # drop all capabilities
      };
      environment = {
        PIXIVFE_PORT = 8282;
        PIXIVFE_HOST = "0.0.0.0";
        PIXIVFE_IMAGEPROXY = "https://pximg.soopy.moe";
        PIXIVFE_CACHE_ENABLED = "true";
      };
      env_file = lib.singleton (secrets.getTemplate "pixivfe.env");
    };
  };

  services.nginx = {
    # cash money
    proxyCachePath."pximg" = {
      enable = true;
      maxSize = "10g";
      inactive = "30d";
      keysZoneName = "pximg";
    };

    virtualHosts."pximg.soopy.moe" = _utils.mkVhost {
      locations."/" = {
        recommendedProxySettings = false;
        proxyPass = "https://i.pximg.net";
        extraConfig = ''
          # bypass
          proxy_set_header Host i.pximg.net;
          proxy_set_header Referer "https://www.pixiv.net/";
          proxy_set_header User-Agent "Mozilla/5.0 (Windows NT 10.0; rv:133.0) Gecko/20100101 Firefox/133.0";
          add_header x-cache-status $upstream_cache_status;

          # cache config
          proxy_cache pximg;
          proxy_cache_lock on;
          proxy_cache_valid 200 30d;
          proxy_cache_valid 404 5m;
          proxy_cache_revalidate on;
          proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
        '';
      };
      locations."= /" = _utils.mkNginxFile {
        content = ''
          nope (i mean yes sure but nop)
        '';
      };
    };

    virtualHosts."pxv.soopy.moe" = _utils.mkSimpleProxy {
      port = 35284;
    };
  };
}
