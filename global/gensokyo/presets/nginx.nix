{
  lib,
  config,
  ...
}:
let
  presetConf = config.gensokyo.presets;
in
lib.mkIf presetConf.nginx (
  lib.mkMerge [
    {
      services.nginx = {
        enable = lib.mkDefault true;
        enableReload = lib.mkDefault true;

        statusPage = true;

        clientMaxBodySize = lib.mkDefault "5m";
        recommendedTlsSettings = lib.mkDefault true;
        recommendedProxySettings = lib.mkDefault true;

        logError = "/var/log/nginx/error.log crit"; # override so we don't log to stderr.
        commonHttpConfig = ''
          # we already set this, hide that from proxied servers that set the header.
          proxy_hide_header strict-transport-security;

          log_format anonymized_combined '0.0.0.0 - - [$time_local] "$request" '
                                         '$status $body_bytes_sent "-" '
                                         '"$http_user_agent" "host=$host;timing=$request_time"';
          access_log /var/log/nginx/access.log anonymized_combined;
        '';

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
          static_configs = [
            { targets = [ "localhost:${builtins.toString config.services.prometheus.exporters.nginx.port}" ]; }
          ];
          relabel_configs = [
            {
              target_label = "instance";
              replacement = "${config.networking.fqdnOrHostName}";
            }
          ];
        }
      ];
    })
  ]
)
