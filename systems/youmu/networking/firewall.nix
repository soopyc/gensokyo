{
  networking.firewall.allowedUDPPorts = [
    53 # dns
    67 # dhcpd
    69 # tftp
  ];
}
