# {inputs, config, hostname, ...}: {
{
  config,
  inputs,
  ...
}: {
  sops.secrets = {
    "vsftpdUsers.db" = {
      sopsFile = inputs.self + "/creds/sops/koumakan/vsftpdUsers.db";
      owner = config.users.users.vsftpd.name;
      format = "binary";
    };

    "webdav.scan.htpasswd" = {
      sopsFile = inputs.self + "/creds/sops/koumakan/webdav.scan.htpasswd";
      owner = config.services.webdav-server-rs.user;
      format = "binary";
    };
  };

  users = {
    users.vsftpd.uid = 3000;
    groups.vsftpd.gid = 3000;
  };

  services.vsftpd = {
    enable = true;
    enableVirtualUsers = true;
    localRoot = "/var/www/ftp";
    localUsers = true;

    userDbPath = config.sops.secrets."webdav.scan.htpasswd".path;
    userlistEnable = true;
    userlist = [
      "brother_scan"
    ];
  };

  services.webdav-server-rs = {
    user = "vsftpd";
    group = "vsftpd";
    enable = true;
    settings = {
      server.listen = ["100.100.16.16:38563"];
      accounts.auth-type = "htpasswd.default";

      htpasswd.default.htpasswd = config.sops.secrets."webdav.scan.htpasswd".path;
      unix.min-uid = 1000;

      location = [
        {
          path = "/*path";
          auth = "true";

          directory = "/var/www/ftp";
        }
      ];
    };
  };
}
