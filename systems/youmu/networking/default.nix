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
    # nettools
  ];

  systemd.services."nftables" = {
    serviceConfig.RestartSec = "5s"; # this cannot fail, retry indefinitely
    after = [
      "systemd-networkd.service"
    ];
  };
}
