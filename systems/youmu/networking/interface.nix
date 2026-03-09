{
  networking.useNetworkd = true;
  networking.networkmanager.enable = false;

  systemd.network = {
    netdevs."50-wan-if" = {
      netdevConfig = {
        Kind = "vlan";
        Name = "wan0";
      };

      vlanConfig = {
        Id = 99;
        # Protocol = "802.1q"; # BUG in nixpkgs: missing defined options for valid systemd options
      };
    };

    networks."30-main-if" = {
      matchConfig = {
        Type = "ether";
        Name = "!wan0"; # anything that's not wan0
      };

      networkConfig = {
        DHCP = false;
        IgnoreCarrierLoss = "30s";
        VLAN = [
          "wan0"
        ];

        Address = [
          # ipv4
          "10.69.0.1/16"
          # ipv6 via interface tracking
        ];

        IPMasquerade = "ipv4";
        IPv4Forwarding = true;
      };

      linkConfig = {
        ARP = true;
      };
    };

    networks."50-wan-net" = {
      matchConfig = {
        Type = "vlan";
        Name = "wan0";
      };

      networkConfig = {
        # ISP ONT gives us a IPv4/6 IP with DHCP.
        DHCP = true;
        IPv6PrivacyExtensions = false;
        # don't set this sis what are you stupid you wasted a week debugging this fuckin option
        # this causes routing problems and fills up your arp table. don't do that.
        DefaultRouteOnDevice = false;
      };

      linkConfig = {
        ARP = true;
        RequiredForOnline = true;
      };

      dhcpV4Config = {
        UseDNS = true;
        UseRoutes = true;
        UseGateway = true;
        SendRelease = false;
      };

      dhcpV6Config = {
        DUIDType = "uuid";
        DUIDRawData = "00:00:00:04:B2:FE:38:D1:39:34:2D:F6:60:37:5F:34:D3:4D:21:CF";
        SendRelease = false;
      };
    };
  };
}
