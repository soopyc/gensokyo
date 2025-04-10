{...}: {
  imports = [
    ./ip-bans.nix
  ];

  networking.firewall = {
    enable = true;

    # this was never needed because ts has been bypassing the firewall anyways. (by being higher on the list.)
    # trustedInterfaces = [
    #   "tailscale0"
    # ];
  };

  # services.openssh.openFirewall = false;
}
