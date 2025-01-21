{
  pkgs,
  lib,
  ...
}: let
  serviceHardening = {
    PrivateUsers = true;
    LockPersonality = true;
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectClock = true;
    ProtectSystem = true;
    ProtectProc = true;
    ProtectHome = true;
    PrivateTmp = true;
    PrivateDevices = false; # cage's drmGetDevices need devices despite being headless.
    SystemCallArchitectures = "native";
    CapabilityBoundingSet = null;
    NoNewPrivileges = true;
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
    ];
    SystemCallFilter = [
      "@system-service"
      # "~@privileged" # cage/wlroots needs setgid for some reason?
    ];
  };
in {
  users.users.funny = {
    isSystemUser = true;
    group = "funny";
  };
  users.groups.funny = {};

  systemd.services = {
    cage-feh = {
      wantedBy = ["multi-user.target"];
      serviceConfig =
        {
          User = "funny";
          RuntimeDirectory = "funny";
          Restart = "on-failure";
          RestartSec = "1";
        }
        // serviceHardening;
      path = with pkgs; [cage feh];
      script = ''
        set -e
        cage -d feh -- -.dz -D10 --draw-tinted /srv/funny
      '';
      environment = {
        WLR_BACKENDS = "headless";
        WLR_LIBINPUT_NO_DEVICES = "1";
        XDG_RUNTIME_DIR = "%t/funny"; # if this is set to %t only, it fails with a cryptic "invalid argument" error but in fact it's probably just a permission denied error.
      };
    };

    wayvnc-feh = {
      wantedBy = ["multi-user.target"];
      requires = ["cage-feh.service"];
      after = ["cage-feh.service"];
      serviceConfig =
        {
          User = "funny";
          RuntimeDirectory = "funny";
          ExecStart = "${lib.getExe pkgs.wayvnc} -d 0.0.0.0";
          Restart = "on-failure";
          RestartSec = "1";
        }
        // serviceHardening;
      environment = {
        WAYLAND_DISPLAY = "wayland-0";
        XDG_RUNTIME_DIR = "%t/funny";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    5900 # vnc; yes this is intended.
  ];
}
