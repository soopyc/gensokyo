{
  config,
  ...
}: {
  services.victoriametrics = {
    enable = true;
    listenAddress = "127.0.0.1:20090";
    retentionPeriod = 5 * 12; # 5 years
  };

  services.vmagent = {
    enable = true;
    remoteWriteUrl = "http://${config.services.victoriametrics.listenAddress}/api/v1/write";
    prometheusConfig = {
      global = {
        scrape_interval = "1m";
      };

      scrape_configs = [
        {
          job_name = "vm_koumakan";
          static_configs = [{targets = ["${builtins.toString config.services.victoriametrics.listenAddress}"];}];
        }

        # node exporters
        {
          job_name = "koumakan";
          static_configs = [{targets = ["localhost:${builtins.toString config.services.prometheus.exporters.node.port}"];}];
        }

        # other services' metrics
        {
          job_name = "nginx_koumakan";
          static_configs = [{targets = ["localhost:${builtins.toString config.services.prometheus.exporters.nginx.port}"];}];
        }

      ];
    };
  };
}
