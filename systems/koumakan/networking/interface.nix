{
  systemd.network.networks."50-enp3s0-static-ips" = {
    enable = true;
    DHCP = "ipv4";

    name = "enp3s0";

    address = [
      # public internet
      "2404:c800:9133:2709:b2c::16/64"

      # dn42
      "172.20.13.225/28"
      "fddd:443:3c3c:a5ea::16/64"
    ];
  };
}
