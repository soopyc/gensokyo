{ lib, ... }: {
  networking = {
    networkmanager.enable = lib.mkForce false;
    useNetworkd = true;
  };

  systemd.network = {
    enable = true;

    networks."10-gensonet" = {
      name = "enp1s0";

      networkConfig = {
        DHCP = "no";
      };

      address = [
        "188.245.74.198/32"
        "2a01:4f8:1c1c:cc9d::cafe/64"
      ];

      routes = [
        # ????????????
        # ig this is needed if the link doesn't have a subnet addr for this address already
        {
          Destination = "172.31.1.1";
        }
        {
          Gateway = "172.31.1.1";
          Destination = "0.0.0.0/0";
        }
        {
          Gateway = "fe80::1";
        }
      ];

      #   "fe80::9400:3ff:fe8b:9312/64" # link-local
      # ];
      # routes = [
      #   { Gateway = "172.31.1.1"; }
      #   { Gateway = "fe80::1"; }
      # ];
    };
  };
}
