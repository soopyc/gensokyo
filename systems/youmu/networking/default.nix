{ pkgs, ... }:
{
  imports = [
    ./interface.nix
    ./firewall.nix
    ./dhcp.nix
    ./routing.nix
  ];

  # debugging tools
  environment.systemPackages = with pkgs; [
    tcpdump
    nettools
  ];
}
