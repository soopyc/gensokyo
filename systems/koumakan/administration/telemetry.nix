{ ... }:
{
  services.prometheus.exporters = {
    node = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = 20091;
      enabledCollectors = [
        "systemd"
      ];
    };

    nginx = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = 20101;
    };
  };
}
