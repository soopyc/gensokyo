{
  hostname,
  lib,
  config,
  _utils,
  ...
}: let
  secrets = _utils.setupSecrets config {
    namespace = "vmetrics";
    secrets = ["auth"];
  };
in {
  # inb4 this causes conflicts

  config = lib.mkIf config.gensokyo.presets.vmetrics (lib.mkMerge [
    {
      services.prometheus.exporters.node.enable = true;
      services.vmagent.enable = true;
      services.vmagent.remoteWrite.url = "https://panopticon.soopy.moe/api/v1/write";
      services.vmagent.extraArgs = ["-remoteWrite.bearerTokenFile %d/auth_token"];
      services.vmagent.prometheusConfig = {
        global.scrape_interval = "30s";

        scrape_configs = [
          {
            job_name = "node";
            static_configs = [{targets = ["localhost:9100"];}];
            relabel_configs = [
              {
                target_label = "instance";
                replacement = "${hostname}.d.soopy.moe";
              }
            ];
          }
        ];
      };

      systemd.services.vmagent.serviceConfig.LoadCredential = [
        "auth_token:${secrets.get "auth"}"
      ];
    }

    secrets.generate
  ]);
}
