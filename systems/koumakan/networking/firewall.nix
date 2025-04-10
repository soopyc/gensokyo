{ lib, ... }:
{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443 # http[s]

      # sftpgo
      21 # ftp
    ];

    allowedTCPPortRanges = [
      # ftp passive mode
      {
        from = 50000;
        to = 50100;
      }
    ];
    allowedUDPPorts = [
      443 # https over quic (http3)
    ];
  };

  # allow openssh
  services.openssh.openFirewall = lib.mkForce true;
}
