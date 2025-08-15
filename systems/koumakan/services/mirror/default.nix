{ _utils, config, ... }:
{
  imports = [
    ./archt2.nix
  ];

  users.groups."mirror-worker" = { };
  users.users."mirror-worker" = {
    isSystemUser = true;
    group = "mirror-worker";
  };

  services.nginx.virtualHosts."mirror.soopy.moe" = _utils.mkVhost {
    locations."/" = {
      root = "/var/lib/mirrors";
      extraConfig = "autoindex on;";
    };
  };

  services.nginx.virtualHosts."keine.soopy.moe".globalRedirect = "mirror.soopy.moe";

  # provision a directory for mirrors
  systemd.tmpfiles.settings."10-mirrors" = {
    "/var/lib/mirrors".d = {
      mode = "0755";
      user = config.users.users.mirror-worker.name;
    };
  };
}
