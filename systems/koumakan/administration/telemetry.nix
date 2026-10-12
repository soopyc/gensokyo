{ config, ... }:
{
  # TODO: replace this with preset
  gensokyo.ports.nodeExporter = 20091;
  gensokyo.ports.nginxExporter = 20101;

  services.prometheus.exporters = {
    node = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = config.gensokyo.ports.nodeExporter;
      enabledCollectors = [
        "systemd"
      ];
    };

    nginx = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = config.gensokyo.ports.nginxExporter;
    };
  };
}
