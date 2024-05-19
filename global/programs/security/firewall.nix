{...}: {
  networking.firewall = {
    enable = true;

    trustedInterfaces = [
      "tailscale0"
    ];
  };

  services.openssh.openFirewall = false;
}
