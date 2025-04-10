# {inputs, config, hostname, ...}: {
{
  config,
  inputs,
  ...
}:
{
  sops.secrets = {
    "vsftpdUsers.db" = {
      sopsFile = inputs.self + "/creds/sops/koumakan/vsftpdUsers.db";
      owner = config.users.users.vsftpd.name;
      format = "binary";
    };

    "webdav.scan.htpasswd" = {
      sopsFile = inputs.self + "/creds/sops/koumakan/webdav.scan.htpasswd";
      owner = config.users.users.vsftpd.name;
      format = "binary";
    };
  };

  users = {
    users.vsftpd = {
      uid = 3000;
      home = "/var/www/ftp";
    };
    groups.vsftpd.gid = 3000;
  };

  services.vsftpd = {
    enable = true;
    enableVirtualUsers = true;
    localRoot = "/var/www/ftp";
    localUsers = true;
    virtualUseLocalPrivs = true;
    writeEnable = true;

    userDbPath = "/run/secrets/vsftpdUsers";
    userlistEnable = true;
    userlist = [
      "brother_scan"
    ];

    extraConfig = ''
      pasv_min_port=50000
      pasv_max_port=50100
    '';
  };

  services.webdav-server-rs = {
    user = "vsftpd";
    group = "vsftpd";
    enable = true;
    settings = {
      server.listen = [ "100.100.16.16:38563" ];
      accounts.auth-type = "htpasswd.default";

      htpasswd.default.htpasswd = config.sops.secrets."webdav.scan.htpasswd".path;
      unix.min-uid = 1000;

      location = [
        {
          route = [ "/*path" ];
          auth = "true";
          handler = "filesystem";
          methods = [ "webdav-rw" ];

          directory = "/var/www/ftp";
        }
      ];
    };
  };
}
