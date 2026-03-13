{
  networking.firewall = {
    enable = true;

    # with iptables it wasn't necessary.
    # however with nftables this is needed to maintain connectivity.
    trustedInterfaces = [
      "tailscale0"
    ];
  };

  # services.openssh.openFirewall = false;
}
