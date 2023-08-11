{ ... }:

{
  imports = [
    ./firewall.nix
    ./interface.nix
  ];

  networking.hostName = "koumakan";
  networking.networkmanager.enable = true;
}
