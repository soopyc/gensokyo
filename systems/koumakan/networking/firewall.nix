{...}: {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22 # ssh
      80
      443 # http[s]
    ];
  };
}
