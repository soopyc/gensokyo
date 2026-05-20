{ _utils, ... }:
{
  services.nginx.virtualHosts."syd.cno.proxy.soopy.moe" = {
    enableACME = true;
    http2 = true;

    locations."/" = {
      recommendedProxySettings = false;
      extraConfig = ''
        proxy_redirect off;
        proxy_http_version 2;
        proxy_set_header "Connection" "";

        proxy_set_header "Host" "cache.nixos.org";
      '';
      proxyPass = "https://cache.nixos.org";
    };

    locations."= /nix-cache-info" = _utils.mkNginxFile {
      content = ''
        StoreDir: /nix/store
        WantMassQuery: 1
        Priority: 40
      '';
    };
  };
}
