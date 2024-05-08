{
  lib,
  pkgs,
  config,
  ...
}: let
  presetConf = config.gensokyo.presets;
in
  lib.mkIf presetConf.nginx (lib.mkMerge [
    {
      services.nginx = {
        enable = lib.mkDefault true;
        enableReload = lib.mkDefault true;
        package = lib.mkDefault pkgs.nginxQuic;

        statusPage = true;

        clientMaxBodySize = lib.mkDefault "5m";
        recommendedTlsSettings = lib.mkDefault true;
        recommendedProxySettings = lib.mkDefault true;
      };
    }

    (lib.mkIf presetConf.vmetrics {
      services.vmagent.prometheusConfig.scrape_configs = [
        {
          job_name = "nginx";
          static_configs = [{targets = ["localhost:${builtins.toString config.services.prometheus.exporters.nginx.port}"];}];
          relabel_configs = [
            {
              target_label = "instance";
              replacement = "${config.networking.fqdnOrHostName}";
            }
          ];
        }
      ];
    })
  ])
