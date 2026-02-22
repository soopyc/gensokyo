{
  networking.networkmanager.ethernet.macAddress = "stable";

  networking.interfaces."enp3s0" = {
    ipv4.addresses = [
      # dn42
      {
        address = "172.20.13.225";
        prefixLength = 28;
      }
    ];

    ipv6.addresses = [
      {
        address = "2404:c800:9133:2709:b2c::16";
        prefixLength = 64;
      }

      # dn42
      {
        address = "fddd:443:3c3c:a5ea::16";
        prefixLength = 64;
      }
    ];
  };
}
