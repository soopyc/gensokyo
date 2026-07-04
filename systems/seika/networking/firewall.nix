{
  networking.firewall.allowedTCPPorts = [
    80
    443

    25 # smtp
    465 # submissions
    587 # submission (starttls)
    993 # imaps
  ];
}
