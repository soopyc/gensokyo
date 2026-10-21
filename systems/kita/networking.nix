{ lib, ... }: {
  networking.networkmanager.enable = lib.mkForce false;

  systemd.network = {
    enable = true;
    links."10-gensoeth0" = {
      # we only have one real eth interface here
      matchConfig.Kind = "ether";
      linkConfig = {
        AlternativeName = "gensoeth0";
      };
    };

    networks."10-gensonet" = {
      name = "gensoeth0";
      dns = lib.singleton "127.0.0.1";
      address = [
        "188.245.74.198/32"
        "2a01:4f8:1c1c:cc9d::cafe/64"
        "fe80::9400:3ff:fe8b:9312" # link-local
      ];
      routes = [
        { Gateway = "172.31.1.1/32"; }
        { Gateway = "fe80::1/128"; }
      ];
    };
  };
}
