{ _utils, ... }:
{
  virtualisation.arion.projects.breezewiki.settings = {
    services.breezewiki = {
      service = {
        image = "quay.io/pussthecatorg/breezewiki";
        ports = [ "127.0.0.1:35612:10416" ];
        environment = {
          bw_canonical_origin = "https://bw.soopy.moe";
          bw_log_outgoing = "false";
          bw_strict_proxy = "true";
          bw_feature_search_suggestions = "true";
        };
      };
    };

    docker-compose.raw = {
      # https://github.com/compose-spec/compose-spec/blob/main/spec.md#pull_policy
      services.breezewiki.pull_policy = "weekly";
    };
  };

  services.nginx.virtualHosts.".bw.soopy.moe" = _utils.mkSimpleProxy {
    port = 35612;
    extraConfig = {
      useACMEHost = "bw.c.soopy.moe";
    };
  };
}
