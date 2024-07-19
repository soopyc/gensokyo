{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./upgrade-diff.nix
  ];

  # Set default i18n configuration
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # We do not like overlays but sometimes they have to be done
  nixpkgs.overlays = import ./overlays inputs;

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or "unknown";

  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;

  # FIXME: doesn't seem to actually update anything
  system.autoUpgrade = lib.mkDefault {
    enable = false;
    flake = "https://patchy.soopy.moe/cassie/genso-nix/archive/main.tar.gz";
    dates = "*-*-* *:00/15:00";
    flags = [
      "--options"
      "tarball-ttl"
      "0"
    ];
    allowReboot = false; # this breaks our current setup with encrypted secureboot
  };

  boot.tmp = {
    useTmpfs = true;
    cleanOnBoot = true;
  };

  # # Enable crash dumps globally
  # boot.crashDump = {
  #   enable = true;
  #   reservedMemory = "128M";
  # };

  time.timeZone = "Asia/Hong_Kong";

  # Lock root account
  users.users.root.shell = pkgs.shadow; # basically /bin/nologin
}
