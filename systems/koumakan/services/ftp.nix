let
  mkUser = {
    # inherit hashedPassword;
    isNormalUser = true;
    home = "/homeless-shelter";
    useDefaultShell = false;
    extraGroups = [ "ftp-ingress" ];
  };
in
{
  gensokyo.ports.vsftpd = 21;
  systemd.tmpfiles.settings."ftp.conf" = {
    "/var/www/ftp".d = {
      mode = "0775";
      user = "root";
      group = "root";
    };
    "/var/www/ftp/ingress" = {
      d = {
        mode = "0770";
        user = "root";
        group = "ftp-ingress";
      };
      a.argument = "g::rw,o::,m::rw";
    };
    "/var/www/ftp/ingress/collate" = {
      d = {
        mode = "0770";
        user = "root";
        group = "ftp-ingress";
      };
    };
  };

  users = {
    groups.ftp-ingress.gid = 3000;
    users.akkoma-L3750CDW = mkUser;
  };

  security.pam.services."vsftpd" = { };
  services.vsftpd = {
    enable = true;
    anonymousUser = false;
    localRoot = "/var/www/ftp";
    userlistEnable = true;
    userlistDeny = false;
    userlist = [
      "akkoma-L3750CDW"
    ];
    localUsers = true;
    writeEnable = true;
    extraConfig = ''
      pasv_min_port=50000
      pasv_max_port=50100
      local_umask=0111
    '';
  };
}
