{_utils, ...}: {
  services.radicale = {
    enable = true;
    settings = {
      auth = {
        type = "htpasswd";
        htpasswd_filename = "/etc/radicale/users";
        htpasswd_encryption = "bcrypt";
      };
      storage = {
        filesystem_folder = "/var/lib/radicale/collections"; # match StateDirectory
      };
      rights.type = "owner_only"; # make this explicit
    };
  };

  systemd.tmpfiles.rules = [
    "d /etc/radicale 0700 radicale" # rest parameters can be ignored/omitted as it's the same as setting a - value.
    # will need to manually create a htpasswd file there but it should be fine. best case scenario is to use sops but i'm tired of dealing with it.
  ];

  services.nginx.virtualHosts."dav.soopy.moe" = _utils.mkSimpleProxy {
    port = 5232;
    extraConfig.useACMEHost = "kita-web.c.soopy.moe";
  };
}
