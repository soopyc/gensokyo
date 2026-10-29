{
  lib,
  pkgs,
  config,
  _utils,
  ...
}:
let
  passSecrets = _utils.setupSecrets config {
    namespace = "passwords";
    secrets = [
      "cassie"
    ];
    config.neededForUsers = true;
  };
in
{
  imports = [
    passSecrets.generate

    ./disk.nix
    ./services
    ./telemetry
    ./networking
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.cassie.hashedPasswordFile = passSecrets.get "cassie";

  # beeper on startup/shutdown
  systemd.services."beap-beap-go-away-trafic" =
    let
      beep = lib.getExe pkgs.beep;
    in
    {
      wantedBy = lib.singleton "multi-user.target";
      conflicts = lib.singleton "shutdown.target";
      before = lib.singleton "shutdown.target";

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;

        DynamicUser = true;
        SupplementaryGroups = lib.singleton "input";
        ReadWritePaths = lib.singleton "/dev/input/by-path/platform-pcspkr-event-spkr";

        ExecStart = "${beep} -f1200 -l250";
        ExecStop = "${beep} -r2 -f800 -l100";

        ProtectProc = true;
        ProtectHome = true;
        PrivateNetwork = true;
        ProtectSystem = "strict";
      };
    };

  gensokyo.traits = {
    ephemeral = true;
    # sensitive = true; # TODO: turn this back on after verified connectivity
  };
  gensokyo.presets.vmetrics = true;

  system.stateVersion = "25.11";
}
