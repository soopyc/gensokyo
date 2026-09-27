{
  inputs,
  config,
  lib,
  _system,
  _utils,
  ...
}:
let
  # stable nixpkgs (@26.05) has v6 which is practically unusable compared to v7 in unstable.
  python3Packages = inputs.nixpkgs-unstable.legacyPackages.${_system}.python3Packages;
  pkg = python3Packages.buildPythonApplication (final: {
    __structuredAttrs = true;

    name = "gtck-webhook";
    pyproject = false;
    dontUnpack = true;

    dependencies = with python3Packages; [
      icalendar
      requests
    ];

    installPhase = ''
      runHook preInstall
      install -Dm755 "${./getsuyo.py}" "$out/bin/getsuyo"
      runHook postInstall
    '';
    meta.mainProgram = "getsuyo";
  });

  secrets = _utils.setupSecrets config {
    namespace = "getsuyo";
    secrets = lib.singleton "discord-webhook-url";
  };
in
{
  imports = lib.singleton secrets.generate;

  systemd = {
    services."getsuyobot" = {
      serviceConfig = {
        ExecStart = lib.getExe pkg;
        LoadCredential = [
          "discord-webhook-url:${secrets.get "discord-webhook-url"}"
        ];
        DynamicUser = true;
        ProtectSystem = "strict";
        ProtectDevices = true;
        ProtectKernelTunables = true;
      };
    };

    timers."getsuyobot" = {
      wantedBy = lib.singleton "multi-user.target";
      timerConfig.OnCalendar = "Sun,Tue 17:00:00 Etc/GMT-8";
    };
  };
}
