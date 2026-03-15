{ lib, ... }:
{
  networking.firewall = {
    enable = true;

    # with iptables it wasn't necessary.
    # however with nftables this is needed to maintain connectivity.
    trustedInterfaces = [
      "tailscale0"
    ];

    # reduce spam
    logRefusedConnections = lib.mkDefault false;
  };

  # services.openssh.openFirewall = false;
}
