{ lib, traits, ... }:
let
  mkDevice = name: id: {
    inherit name;
    value = {
      inherit id;
      addresses = [
        "tcp://${name}.mist-nessie.ts.net"
        "quic://${name}.mist-nessie.ts.net"
      ];
    };
  };
  devices = lib.listToAttrs [
    (mkDevice "renko" "JSPWYCM-O76XTAY-IEP3AKI-A2IK4KX-X2NC7N4-ADMQKXY-VYM45XX-OADHHA3")
    (mkDevice "satori" "OZ2QYJS-463IWPW-DXL6OKH-BU2D2QK-ZP577US-BYXSMAA-LAXRWV7-6PC54QF")
  ];
  allDevices = lib.attrNames devices;
in
lib.mkIf (traits.gui) {
  services.syncthing = {
    enable = true;
    settings = {
      inherit devices;
      options.globalAnnounceEnabled = false;
      defaults.ignores = [
        "(?d)**/node_modules"
        "(?d)**/target"
        "(?d)**/.svelte-kit"
      ];
      folders = {
        "/home/cassie/projects/synced" = {
          id = "synced-projects";
          devices = allDevices;
        };
      };
    };
  };
}
