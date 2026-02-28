{ lib, ... }:
{
  systemd.network.networks."50-enp3s0-static-ips" = {
    enable = true;
    name = "enp3s0";
    DHCP = "ipv6";

    gateway = lib.singleton "10.69.0.1"; # ip4 NAT gateway
    address = [
      # natted private ip
      "10.69.2.16/16"

      # public internet
      "2404:c805:33dd:9900::16/56"

      # dn42
      # TODO: move this to another interface
      # "172.20.13.225/28"
      # "fddd:443:3c3c:a5ea::16/64"
    ];
  };
}
