{
  lib,
  pkgs,
  config,
  ...
}:
let
  imageTypes = {
    "summary" = "--summary";
    "summary-graph-vertical" = "--vsummary";
    "summary-graph-horizontal" = "--hsummary";
    "5min" = "--fiveminutes";
    "5min-graph" = "--fivegraph";
    "hourly" = "--hours";
    "hourly-graph" = "--hoursgraph";
    "daily" = "--days";
    "monthly" = "--months";
    "yearly" = "--years";
    "top" = "--top";
    "95th" = "--95th 2"; # total
  };
  imagesMeta = pkgs.writers.writeJSON "metadata.json" (
    lib.map (x: x + ".png") (builtins.attrNames imageTypes)
  );
in
{
  services.vnstat.enable = true;

  # i don't know what format this is
  environment.etc."vnstat.conf".text = ''
    # ; and # marks comments. upstream uses ; for default config entries so we'll follow suit.

    # default interface
    Interface wan0

    # default list output entry limits (0 = all)
    ;List5Mins      24
    ;ListHours      24
    ListDays        31
    ;ListMonths     12
    ;ListYears       0
    ListTop         15

    # db settings
    UseUTC          1
    UpdateInterval 10
    SaveInterval    5
    DatabaseWriteAheadLogging 1

    # vnstati
    BarColumnShowsRate 1
    CBackground        "FFFFFF"
    CEdge              "AEAEAE"
    CHeader            "606060"
    CHeaderTitle       "FFFFFF"
    CHeaderDate        "FFFFFF"
    CText              "000000"
    CLine              "B0B0B0"
    CLineL             "-"
    CRx                "83C9FF"
    CTx                "FFABDF"
    CRxD               "-"
    CTxD               "-"
  '';

  systemd = {
    tmpfiles.settings."50-vnstati-images"."/srv/www/vnstat/".D = {
      user = config.users.users.vnstatd.name;
      group = config.users.groups.vnstatd.name;
      mode = "0755";
    };

    timers."vnstati" = {
      wantedBy = lib.singleton "multi-user.target";
      timerConfig.OnCalendar = "*:*"; # *:*:0 => every minute
    };

    services."vnstati" = {
      path = lib.singleton config.services.vnstat.package;
      serviceConfig = {
        User = "vnstatd";
        Group = "vnstatd";
        StateDirectory = "vnstat";

        ReadWritePaths = lib.singleton "/srv/www/vnstat/";
        ConditionPathExists = "/var/lib/vnstat/vnstat.db";

        NoNewPrivileges = true;
        PrivateNetwork = true;
        ProtectSystem = "strict";
        ProtectHome = true;
      };

      script = ''
        set -euxo pipefail
        test -e /srv/www/vnstat/metadata.json && rm /srv/www/vnstat/metadata.json
        ln -sv ${imagesMeta} /srv/www/vnstat/metadata.json
        ${lib.concatLines (
          lib.mapAttrsToList (k: v: "vnstati ${v} -o /srv/www/vnstat/${k}.png") imageTypes
        )}
      '';
    };
  };
}
