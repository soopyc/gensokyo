{
  config,
  lib,
  _utils,
  ...
}:
let
  monitoredHosts = [
    "satori"
    "renko"
    "kita"
    "ryo"
    "nijika"
  ];
  secrets = _utils.setupSecrets config {
    namespace = "vmetrics";
    secrets = builtins.map (f: "auth/hosts/" + f) monitoredHosts;
  };
in
{
  imports = [
    secrets.generate

    (secrets.mkTemplate "vmauth.env" (
      lib.concatLines (
        builtins.map (
          host: "AUTH_${lib.toUpper host}_TOKEN=${secrets.placeholder "auth/hosts/${host}"}"
        ) monitoredHosts
      )
    ))
  ];

  services.victoriametrics = {
    enable = true;
    listenAddress = "127.0.0.1:20090";
    retentionPeriod = "5y"; # 5 years
  };

  services.vmagent = {
    enable = true;
    remoteWrite.url = "http://${config.services.victoriametrics.listenAddress}/api/v1/write";
    prometheusConfig = {
      global = {
        scrape_interval = "30s";
      };

      scrape_configs = [
        {
          job_name = "victoriametrics";
          scrape_interval = "15s";
          static_configs = lib.singleton {
            targets = lib.singleton "${builtins.toString config.services.victoriametrics.listenAddress}";
          };
        }

        # node exporters
        {
          job_name = "node";
          scrape_interval = "15s";
          static_configs = lib.singleton {
            targets = lib.singleton "localhost:${builtins.toString config.services.prometheus.exporters.node.port}";
          };
          relabel_configs = lib.singleton {
            target_label = "instance";
            replacement = "koumakan";
          };
        }

        # external nodes uses remote write
        #  [mail, gateway]

        # other services' metrics
        {
          job_name = "nginx";
          static_configs = lib.singleton {
            targets = lib.singleton "localhost:${builtins.toString config.services.prometheus.exporters.nginx.port}";
          };
          relabel_configs = lib.singleton {
            target_label = "instance";
            replacement = "koumakan";
          };
        }
      ];
    };
  };

  # vmetrics docs suggests NOT to expose any vmetrics component to the public except vmauth or vmgateway, so we're not going to do that.
  # this unfortunately requires a custom module which we have written ourselves, and might upstream to core nixpkgs when we are sure of its stability.
  # some may wonder why we can't just use nginx directly instead of another module
  # i mean, yeah. vmauth is honestly just another nginx. whatever, i do not care. i'm tired.

  # module search: https://mystia.soopy.moe
  services.vmauth = {
    enable = true;
    listenAddress = "127.0.0.1:21000";
    authConfig = {
      users = builtins.concatMap (
        token:
        lib.singleton {
          bearer_token = token;
          url_prefix = "http://${config.services.victoriametrics.listenAddress}"; # send directly to vm
        }
      ) (builtins.map (host: "%{AUTH_${lib.toUpper host}_TOKEN}") monitoredHosts);
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
      return 200 "200 big sister is watching you.";
    '';

    # Allow only the write route
    locations."~* /api/.*/write" = {
      proxyPass = "http://127.0.0.1:21000";
    };
  };
}
