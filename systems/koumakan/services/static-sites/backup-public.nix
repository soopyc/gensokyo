{
  _utils,
  lib,
  config,
  ...
}:
{
  services.nginx.virtualHosts."backups.soopy.moe" = _utils.mkVhost {
    locations."/" = {
      root = "/home/backup/public/";
      extraConfig = ''
        autoindex on;
        autoindex_exact_size off;
      '';
    };
  };

  systemd.services.nginx.serviceConfig.BindReadOnlyPaths = lib.singleton "/home/backup/public";
  users.users.nginx.extraGroups = lib.singleton config.users.users.backup.name;
}
