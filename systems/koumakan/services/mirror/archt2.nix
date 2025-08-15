{ pkgs, ... }:
{
  systemd = {
    # TODO: make this a gensokyo module
    timers."mirror-sync-t2" = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      timerConfig = {
        OnCalendar = "*:30";
        RandomizedDelaySec = "600s";
        DeferReactivation = true;
        Persistent = true;
      };
    };

    services."mirror-sync-t2" = {
      path = [ pkgs.rsync ];
      script = ''
        mkdir -p /var/lib/mirrors/{arch,endeavouros}-mact2

        rsync -rlptH --safe-links --delete-delay --delay-updates \
          rsync://mirror.funami.tech/arch-mact2 /var/lib/mirrors/arch-mact2

        rsync -rlptH --safe-links --delete-delay --delay-updates \
          rsync://mirror.funami.tech/endeavouros-mact2 /var/lib/mirrors/endeavouros-mact2
      '';

      serviceConfig = {
        User = "mirror-worker";
      };
    };
  };
}
