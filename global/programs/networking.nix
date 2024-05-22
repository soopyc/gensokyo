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
  }

  (lib.mkIf config.gensokyo.traits.portable {
    networking = {
      wireless.iwd.enable = true;
      networkmanager.wifi.backend = "iwd"; # iwd works significantly better than wpa_supplicant. however w_s has hotspot support and iwd doesn't. though w_s' hotspot is like, not usable so whatever.
    };
  })

  (lib.mkIf (!config.gensokyo.traits.sensitive) {
    services.avahi = {
      publish.enable = true;
    };
  })
]
