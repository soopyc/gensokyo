{ lib, pkgs, ... }: {
  systemd.user = {
    timers.backup-2025 = {
      wantedBy = lib.singleton "default.target";
      timerConfig = {
        OnCalendar = "*:0/5";
        AccuracySec = "1us";
      };
    };

    services.backup-2025 = {
      path = with pkgs; [
        rsync
        openssh
      ];
      script = ''
        SOURCE="/home/cassie/mcservers/season-2025"
        DESTINATION="backup@koumakan:/home/backup/public/"
        rsync \
          -rltH \
          --rsh="ssh -i $HOME/.ssh/id_backup_koumakan" \
          --safe-links \
          --delay-updates \
          --human-readable --progress \
          --exclude="*/bluemap/web" \
          --exclude="*/libraries" \
          --exclude=".fabric" \
          --exclude="*.tmp" \
          --exclude="*/tmp" \
          --exclude="DistantHorizons.sqlite*" \
          --verbose \
          $SOURCE \
          $DESTINATION
    '';
    };
  };
}
