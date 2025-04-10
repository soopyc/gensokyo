{
  pkgs,
  inputs,
  ...
}:
{
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

  boot.tmp = {
    useTmpfs = false; # this causes oom on kernel builds
    cleanOnBoot = true;
  };

  boot.crashDump.enable = true;

  time.timeZone = "Asia/Hong_Kong";

  # Lock root account
  users.users.root.shell = pkgs.shadow; # basically /bin/nologin
}
