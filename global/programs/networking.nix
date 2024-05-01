{lib, config, ...}: lib.mkMerge [
  {
    networking.networkmanager.enable = true;
    networking.domain = "d.soopy.moe";
  }

  (lib.mkIf config.gensokyo.traits.portable {
    networking = {
      wireless.iwd.enable = true;
      networkmanager.wifi.backend = "iwd"; # iwd works significantly better than wpa_supplicant. however w_s has hotspot support and iwd doesn't. though w_s' hotspot is like, not usable so whatever.
    };
  })
]
