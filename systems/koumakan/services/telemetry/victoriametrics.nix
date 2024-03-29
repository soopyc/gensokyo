{
  config,
  _utils,
  ...
}: let
  secrets = _utils.setupSecrets config {
    namespace = "vmetrics";
    secrets = [
      "agent/akkoma"

      "auth/hosts/mail"
    ];
  };
in {
  imports = [
    secrets.generate
    (secrets.mkTemplate "vmagent.env" ''
      VMA_AKKOMA_CRED=${secrets.placeholder "agent/akkoma"}
    '')

    (secrets.mkTemplate "vmauth.env" ''
      AUTH_MAIL_TOKEN=${secrets.placeholder "auth/hosts/mail"}
    '')
  ];

  services.victoriametrics = {
    enable = true;
    listenAddress = "127.0.0.1:20090";
    retentionPeriod = 5 * 12; # 5 years
  };

  systemd.services.vmagent.serviceConfig.EnvironmentFile = secrets.getTemplate "vmagent.env";

  services.vmagent = {
    enable = true;
    remoteWriteUrl = "http://${config.services.victoriametrics.listenAddress}/api/v1/write";
    prometheusConfig = {
      global = {
        scrape_interval = "30s";
      };

      scrape_configs = [
        {
          job_name = "vm_koumakan";
          scrape_interval = "15s";
          static_configs = [{targets = ["${builtins.toString config.services.victoriametrics.listenAddress}"];}];
        }

        # node exporters
        {
          job_name = "koumakan";
          scrape_interval = "15s";
          static_configs = [{targets = ["localhost:${builtins.toString config.services.prometheus.exporters.node.port}"];}];
        }

        # mail node uses remote write to vmagent.

        # other services' metrics
        {
          job_name = "nginx_koumakan";
          static_configs = [{targets = ["localhost:${builtins.toString config.services.prometheus.exporters.nginx.port}"];}];
        }

        {
          job_name = "akkoma";
          static_configs = [{targets = ["a.soopy.moe"];}];
          scheme = "https";
          authorization = {credentials = "%{VMA_AKKOMA_CRED}";};
          metrics_path = "/api/v1/akkoma/metrics";
        }
      ];
    };
  };

  # vmetrics docs suggests NOT to expose any vmetrics component to the public except vmauth or vmgateway, so we're not going to do that.
  # this unfortunately requires a custom module which we have written ourselves, and might upstream to core nixpkgs when we are sure of its stability.
  # some may wonder why we can't just use nginx directly instead of another module
  # i mean, yeah. vmauth is honestly just another nginx. whatever, i do not care. i'm tired.

  # TODO: (frontend, ugh) write a lightweight search engine for flake modules.
  #  -> has to be reasonably sandboxed so people can't run random shit on my systems
  services.vmauth = {
    enable = true;
    listenAddress = "127.0.0.1:21000";
    authConfig = {
      users = [
        {
          bearer_token = "%{AUTH_MAIL_TOKEN}";
          url_prefix = "http://${config.services.victoriametrics.listenAddress}"; # send directly to vm
        }
      ];
    };
    environmentFile = secrets.getTemplate "vmauth.env";
  };

  # expose vmauth remote write endpoint
  services.nginx.virtualHosts."panopticon.soopy.moe" = _utils.mkVhost {
    # Deny all routes by default
    # This is strictly a write-only exposure so anything else can explod.
    locations."/".return = "444";

    locations."= /".extraConfig = ''
      add_header content-type text/plain;
      return 200 "big sister is watching you.\n\nhttps://http.cat/101";
    '';

    # Allow only the write route
    locations."~* /api/.*/write" = {
      proxyPass = "http://127.0.0.1:21000";
    };
  };
}
