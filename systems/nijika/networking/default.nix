{
  imports = [
    ./interface.nix
    ./firewall.nix
  ];

  networking.useNetworkd = true;
  systemd.network.enable = true;
}
