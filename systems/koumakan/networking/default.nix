{ lib, ... }:
{
  imports = [
    ./firewall.nix
    ./interface.nix
  ];

  systemd.network.enable = true;
  networking.useNetworkd = true;
  networking.networkmanager.enable = lib.mkForce false;
}
