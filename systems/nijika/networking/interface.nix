{
  systemd.network.networks."50-ether-ipv6" = {
    enable = true;
    name = "enp0s6";

    address = [
      "2603:c022:4006:7c5a::33/128"
    ];
  };
}
