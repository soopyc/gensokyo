{
  gensokyo.ports.vsftpd = 21;
  users.groups.ftp-ingress.gid = 3000;
  systemd.tmpfiles.settings."ftp-ingress.conf"."/var/www/ftp/ingress" = {
    d = {
      mode = "0770";
      user = "root";
      group = "ftp-ingress";
    };
    a.argument = "g::rw,o::,m::rw";
  };

  containers."vsftpd" = {
    autoStart = true;
    bindMounts."/var/www/ftp" = {
      hostPath = "/var/www/ftp";
      isReadOnly = false;
    };
    privateUsers = "pick";

    config =
      let
        mkUser = hashedPassword: {
          inherit hashedPassword;
          isNormalUser = true;
          home = "/homeless-shelter";
          useDefaultShell = false;
          extraGroups = [ "paperless" ];
        };
      in
      {
        users = {
          allowNoPasswordLogin = true; # brother i'm in a container
          mutableUsers = false;
          groups.ftp-ingress.gid = 3000;
          users.akkoma-L3750CDW = mkUser "$y$j9T$sKgJPvXEQwr0Jv9q.oIYF.$BhnLfoYWjZ07UQ3L4SKoCTI0RHtaicMLKvyoL4LT6XD";
          users.soopyc = mkUser "$y$j9T$ZxenYquhn9VGhJrhYjH4q1$7JiiNH1BFVsSkz/WlTiScTRto8BJL/AP7F2PSuMpC7A";
        };

        services.vsftpd = {
          enable = true;
          userlist = [
            "soopyc"
            "akkoma-L3750CDW"
          ];
          localUsers = true;
          writeEnable = true;
          extraConfig = ''
            pasv_min_port=50000
            pasv_max_port=50100
          '';
        };
      };
  };
}
