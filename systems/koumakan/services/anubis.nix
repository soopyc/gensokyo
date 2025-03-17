{
  lib,
  config,
  ...
}: {
  assertions =
    lib.mapAttrsToList (k: v: {
      # assertion = v.settings.METRICS_BIND_NETWORK == "tcp" -> !builtins.isNull (builtins.match "127.0.0.1:.*" v.settings.METRICS_BIND);
      assertion = !builtins.isNull (builtins.match "^127.0.0.1:17[[:digit:]]\{3\}$" v.settings.METRICS_BIND); # stricter
      message = "koumakan-internal(anubis `${k}`): settings.METRICS_BIND must be in the form `127.0.0.1:17xxx`";
    })
    config.services.anubis.instances;

  # neither VM nor Prom supports scraping unix domain sockets and i currently cba writing a custom scraper for it
  # prom: https://github.com/prometheus/prometheus/issues/12024
  # TODO: do that
  services.anubis.defaultOptions.settings.METRICS_BIND_NETWORK = "tcp";

  services.vmagent.prometheusConfig.scrape_configs = lib.mapAttrsToList (k: v: {
    job_name = "anubis";
    static_configs = lib.singleton {
      targets = lib.singleton v.settings.METRICS_BIND;
    };
    relabel_configs = [
      {
        target_label = "instance";
        replacement = "koumakan";
      }
      {
        target_label = "anubis_instance";
        replacement = k;
      }
    ];
  }) (lib.filterAttrs (_: v: v.enable) config.services.anubis.instances);
}
