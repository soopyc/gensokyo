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

      # minecraft
      {
        from = 25560;
        to = 25599;
      }
    ];
    allowedUDPPorts = [
      443 # https over quic (http3)
    ];

    allowedUDPPortRanges = [
      # more minecraft
      {
        from = 25560;
        to = 25599;
      }

      # plasmo voice
      {
        from = 55111;
        to = 55199;
      }
    ];
  };

  # allow openssh
  services.openssh.openFirewall = lib.mkForce true;
}
