{
  pkgs,
  config,
  ...
}: let
  # HACK
  nixos-version = "/run/current-system/sw/bin/nixos-version";
  motd = pkgs.writeText "motd-custom" ''
    i                                                88
    i                                  ,d            88
    i                                  88            88
    i  88,dPYba,,adPYba,   ,adPPYba, MM88MMM ,adPPYb,88
    i  88P'   "88"    "8a a8"     "8a  88   a8"    `Y88
    i  88      88      88 8b       d8  88   8b       88
    i  88      88      88 "8a,   ,a8"  88,  "8a,   ,d88
    i  88      88      88  `"YbbdP"'   "Y888 `"8bbdP"Y8

    # Welcome to ${config.system.name}
    # NixOS %nixos_rev%
    #  --> flake:%flake_rev%
    # %linux_srm%

    i System uptime: %uptime%
    i Last updated: %current_time%
  '';
in {
  users.motdFile = "/etc/motd.custom";

  systemd.timers."gensokyo-refresh-motd" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      Unit = "gensokyo-refresh-motd.service";
      # OnCalendar = "*:0/5"; # every 5 minutes -- most readable format
      OnCalendar = "*-*-* *:00/5:00";
      AccuracySec = "2.5min";
    };
  };

  systemd.services."gensokyo-refresh-motd" = {
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    restartTriggers = [
      /etc/static/nix/registry.json
    ];
    script = ''
      set -euo pipefail
      echo "copying and replacing motd from template."
      cp ${motd} /etc/motd.custom
      sed -i "s/%current_time%/$(date -Ins)/g" /etc/motd.custom
      sed -i "s/%nixos_rev%/$(${nixos-version})/g" /etc/motd.custom
      sed -i "s/%flake_rev%/$(${nixos-version} --configuration-revision)/g" /etc/motd.custom
      sed -i "s/%linux_srm%/$(uname -srm)/g" /etc/motd.custom
      sed -i "s/%uptime%/$(uptime | cut -d ' ' -f 5-)/" /etc/motd.custom
      echo "done!"
    '';
  };
}
