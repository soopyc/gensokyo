{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  users = {
    users.backup = {
      isNormalUser = true;
      group = "backup";
      shell = pkgs.bashInteractive;
      packages = with pkgs; [ rsync ];
      openssh.authorizedKeys.keyFiles = lib.singleton (inputs.self + "/creds/ssh/users/backup");
      createHome = false;
    };

    groups.backup = { };
  };

  system.activationScripts.initBackupHome = {
    deps = [ "users" ];
    supportsDryActivation = false;
    text = ''
      if test ! -e /home/backup; then
        ${lib.getExe pkgs.btrfs-progs} subvolume create /home/backup
      fi

      chown backup:backup /home/backup
      chmod 0550 /home/backup
      install -dm755 -o backup -g backup /home/backup/public
      install -dm700 -o backup -g backup /home/backup/private
    '';
  };

  systemd = {
    services."snapshot-backup" = {
      path = [ pkgs.btrfs-progs ];
      script = ''
        NOW=$(date -u +%Y%m%d.%H%M%S)
        DATA_PATH=/home/backup/public

        mkdir -p ''${DATA_PATH}/snapshots
        btrfs subvolume snapshot -r $DATA_PATH ''${DATA_PATH}/snapshots/''${NOW}
      '';
      serviceConfig.User = "backup";
    };

    timers."snapshot-backup" = {
      wantedBy = lib.singleton "multi-user.target";
      timerConfig = {
        OnCalendar = "*:0";
        RandomizedDelaySec = "60s";
        AccuracySec = "1us";
      };
      unitConfig.RequiresMountsFor = "/home";
    };
  };
}
