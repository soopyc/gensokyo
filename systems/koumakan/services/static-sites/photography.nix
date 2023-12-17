{
  config,
  pkgs,
  lib,
  _utils,
  ...
}: {
  # TODO: we can make this better by just automating everything needed to make a h5ai site.
  services.phpfpm.pools."photography" = {
    user = "photography";
    settings = {
      "listen.owner" = config.services.nginx.user;
      "pm" = "ondemand";
      "pm.process_idle_timeout" = "3s";
      "pm.max_children" = 32;
      "pm.max_requests" = 500;
      "pm.start_servers" = 1;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
    };
    phpEnv."PATH" = lib.makeBinPath (with pkgs; [
      php
    ]);
  };

  services.nginx.virtualHosts."photography.soopy.moe" = _utils.mkVhost {
    root = "/opt/photography/";
    locations."/" = {
      # what's the purpose of $.fastcgiParams when it's barely even usable
      index = "index.html index.php /_h5ai/public/index.php";
      extraConfig = ''
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:${config.services.phpfpm.pools.photography.socket};
        include ${config.services.nginx.package}/conf/fastcgi.conf;
      '';
    };
  };

  users.users.photography = {
    isSystemUser = true;
    group = "photography";
    createHome = false;
  };
  users.groups.photography = {};

  users.users.cassie.extraGroups = ["photography"];
}
