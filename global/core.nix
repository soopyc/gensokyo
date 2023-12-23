{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./upgrade-diff.nix
    ./motd.nix
  ];

  # Set default i18n configuration
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or "unknown";

  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;

  system.autoUpgrade = lib.mkDefault {
    enable = true;
    flake = "https://patchy.soopy.moe/cassie/genso-nix/archive/main.tar.gz";
    dates = "2.5m";
    flags = [
      "--options"
      "tarball-ttl"
      "0"
    ];
    allowReboot = false; # this breaks our current setup with encrypted secureboot
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
