{...}: {
  imports = [
    ./firewall.nix
    ./interface.nix
  ];

  networking.hostName = "koumakan";
}
