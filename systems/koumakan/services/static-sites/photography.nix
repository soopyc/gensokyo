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

      "php_admin_value[error_log]" = "stderr";
      "php_admin_flag[log_errors]" = true;
      "catch_workers_output" = true;
    };
    phpEnv."PATH" = lib.makeBinPath (with pkgs; [
      zip
    ]);
  };

  services.nginx.virtualHosts."photography.soopy.moe" = _utils.mkVhost {
    root = "/opt/photography";
    extraConfig = ''
      index index.html index.php /_h5ai/public/index.php;
    '';

    locations."~ \.php$" = {
      tryFiles = "$fastcgi_script_name =404";
      # what's the purpose of $.fastcgiParams when it's barely even usable
      # fastcgiParams = {
      #   DOCUMENT_ROOT = "$realpath_root";
      #   SCRIPT_FILENAME = "$realpath_root$fastcgi_script_name";
      # };

      extraConfig = ''
        error_log /var/log/nginx/photography.error.log warn;
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

  users.users.nginx.extraGroups = ["photography"];
  users.users.cassie.extraGroups = ["photography"];
}
