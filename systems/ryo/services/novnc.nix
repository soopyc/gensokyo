{
  _utils,
  pkgs,
  lib,
  ...
}: {
  services.nginx.virtualHosts."ryo.soopy.moe" = _utils.mkSimpleProxy {
    port = 6080;
    websockets = true;
    extraConfig = {
      locations."= /".return = "303 /vnc_lite.html";
      enableACME = true; # don't bother with DNS-01
      useACMEHost = null;
    };
  };

  systemd.services."novnc" = {
    enable = true;
    wantedBy = ["multi-user.target"];
    path = with pkgs; [procps];
    serviceConfig = {
      DynamicUser = true;
      ExecStart = "${lib.getExe pkgs.novnc} --file-only";

      # hardening
      PrivateUsers = true;
      LockPersonality = true;
      ProtectHostname = true;
      ProtectKernelTunables = true;
      ProtectDevices = true;
      ProtectClock = true;
      SystemCallArchitectures = "native";
      CapabilityBoundingSet = null;
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
      ];
      SystemCallFilter = [
        "@system-service"
        "~@privileged"
      ];
    };
  };
}
