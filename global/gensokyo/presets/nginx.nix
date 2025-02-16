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

        # prevent people from just being able to take the server down immediately
        eventsConfig = ''
          worker_connections 1024;
        '';
        appendConfig = ''
          worker_processes auto;
        '';
      };

      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
    }

    (lib.mkIf presetConf.vmetrics {
      services.prometheus.exporters.nginx.enable = true;
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
