{_utils, pkgs, lib, ...}: {
  services.nginx.virtualHosts."ryo.soopy.moe" = _utils.mkSimpleProxy {
    port = 6080;
    websockets = true;
    extraConfig = {
      locations."= /".return = "303 /vnc_lite.html";
      useACMEHost = "ryo.soopy.moe";
    };
  };

  systemd.services."novnc" = {
    serviceConfig = {
      DynamicUser = true;
      ExecStart = "${lib.getExe pkgs.novnc} --file-only";
    };
  };
}
