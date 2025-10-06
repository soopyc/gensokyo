{
  lib,
  config,
  ...
}:
lib.mkMerge [
  {
    networking.networkmanager.enable = true;
    networking.domain = "d.soopy.moe";

    services.avahi = {
      enable = true;
      nssmdns4 = true;
    };

    services.tailscale.enable = true;
    services.tailscale.useRoutingFeatures = "both";

    # disable broken services
    systemd.services.NetworkManager-wait-online.enable = false;

    # reduce spam
    networking.firewall.logRefusedConnections = lib.mkDefault false;

    # use tcp bbr for increased throughput
    boot.kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  }

  (lib.mkIf config.gensokyo.traits.portable {
    networking.networkmanager.wifi.backend = "wpa_supplicant";
  })

  (lib.mkIf (!config.gensokyo.traits.sensitive) {
    services.avahi = {
      publish.enable = true;
    };
  })

  {
    networking.hosts = {
      "217.197.84.140" = [ "codeberg.org" ];
    };
  }
]
