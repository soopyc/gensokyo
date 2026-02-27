{
  systemd.network.networks."50-enp3s0-static-ips" = {
    enable = true;
    name = "enp3s0";
    DHCP = "no";

    address = [
      # natted private ip
      "10.69.2.16/16"

      # public internet
      "2404:c805:33dd:9900::16/64"

      # dn42
      "172.20.13.225/28"
      "fddd:443:3c3c:a5ea::16/64"
    ];
  };
}
