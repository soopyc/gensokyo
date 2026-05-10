{
  imports = [
    ./interface.nix
  ];

  networking.useNetworkd = true;
  systemd.network.enable = true;
}
