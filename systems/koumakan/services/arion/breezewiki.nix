{ _utils, config, ... }:
{
  gensokyo.ports.arion-breezewiki = 35612;
  virtualisation.arion.projects.breezewiki.settings = {
    services.breezewiki = {
      service = {
        image = "quay.io/pussthecatorg/breezewiki";
        ports = [ "127.0.0.1:${toString config.gensokyo.ports.arion-breezewiki}:10416" ];
        environment = {
          bw_canonical_origin = "https://bw.soopy.moe";
          bw_log_outgoing = "false";
          bw_strict_proxy = "true";
          bw_feature_search_suggestions = "true";
        };
      };
    };
  };

  services.nginx.virtualHosts.".bw.soopy.moe" = _utils.mkSimpleProxy {
    port = config.gensokyo.ports.arion-breezewiki;
    extraConfig = {
      useACMEHost = "bw.c.soopy.moe";
    };
  };
}
