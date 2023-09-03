{ pkgs, ... }:
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

  hardware.enableRedistributableFirmware = true;

  # # Enable crash dumps globally
  # boot.crashDump = {
  #   enable = true;
  #   reservedMemory = "128M";
  # };

  # Lock root account
  users.users.root.shell = pkgs.shadow;  # basically /bin/nologin
}
