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
    text =
      let
        btrfs = lib.getExe pkgs.btrfs-progs;
      in
      ''
        ensureSubvolume() {
          mode=$1; shift
          dir=$1; shift

          if test ! -e $dir; then
            ${btrfs} subvolume create $dir
          fi
          chown backup:backup $dir
          chmod $mode $dir
        }

        ensureSubvolume 550 /home/backup
        ensureSubvolume 700 /home/backup/private
        ensureSubvolume 700 /home/backup/private/snapshots
        ensureSubvolume 755 /home/backup/public
        ensureSubvolume 755 /home/backup/public/snapshots
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
