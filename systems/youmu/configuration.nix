{
  lib,
  pkgs,
  config,
  inputs,
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

    inputs.impermanence.nixosModules.default
    inputs.disko.nixosModules.default
  ];

  # impermenance doesn't check neededForBoot for a given mountpoint and that is needed for sops-nix
  # to properly function (i.e. loading the ssh host key)
  # HACK: override sops-nix key path(s) to a location that's known to exist after initrd.
  # we should probably pr this to impermenance or something.
  sops.age.sshKeyPaths = lib.singleton "/persist/etc/ssh/ssh_host_ed25519_key";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";

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

  # gensokyo.traits.sensitive = true; # TODO: turn this back on after verified connectivity

  system.stateVersion = "25.11";
}
