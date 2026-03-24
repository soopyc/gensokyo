{ lib, ... }:
let
  mkSimpleOption = name: data: { inherit name data; };
in
{
  services.kea = {
    dhcp4 = {
      enable = true;
      settings = {
        lease-database = {
          type = "memfile";
          persist = true;
          name = "/var/lib/kea/dhcp4.leases";
        };

        interfaces-config.interfaces = lib.singleton "enp0s31f6";
        valid-lifetime = 86400;

        subnet4 = lib.singleton {
          id = 1;
          subnet = "10.69.0.0/16";
          pools = lib.singleton { pool = "10.69.10.0 - 10.69.50.255"; };

          option-data = [
            (mkSimpleOption "routers" "10.69.0.1")
            # (mkSimpleOption "domain-name" "gensokyo.internal")
            (mkSimpleOption "domain-name-servers" "8.8.8.8,8.8.4.4,1.1.1.1,1.0.0.1") # TODO: replace with our own
            (mkSimpleOption "tftp-server-name" "10.69.0.1") # TODO: make this 4/6 compatible maybe with dns
            # https://kea.readthedocs.io/en/stable/arm/dhcp4-srv.html#setting-fixed-fields-in-classification
            (mkSimpleOption "boot-file-name" "netbootxyz.amd64.efi") # TODO: limit to amd64 devices
          ];
        };
      };
    };

    # TODO: do stuff
    dhcp6 = {
      enable = false;
      settings = { };
    };
  };

  # why are these enabled? it's already running as a user
  systemd.services.kea-dhcp4-server.serviceConfig.DynamicUser = lib.mkForce false;
  systemd.services.kea-dhcp6-server.serviceConfig.DynamicUser = lib.mkForce false;
}
