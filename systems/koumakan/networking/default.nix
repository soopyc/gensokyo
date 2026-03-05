{
  imports = [
    ./firewall.nix
    ./interface.nix
  ];

  systemd.network.enable = true;
  networking.useNetworkd = true;
  networking.networkmanager.enable = false;
}
