{...}: {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22 # ssh
      80
      443 # http[s]

      # sftpgo
      21 # ftp
      38562 # webui
    ];
    allowedUDPPorts = [
      443 # https over quic (http3)
    ];
  };
}
