{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./upgrade-diff.nix
    ./unfree-insecure-allowlist.nix
    ./sysctl.nix
  ];

  # Set default i18n configuration
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "sun12x22";
    keyMap = "us";
  };

  # We do not like overlays but sometimes they have to be done
  nixpkgs.overlays = import ./overlays inputs;

  system.rebuild.enableNg = true;

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or "unknown";

  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;

  boot.tmp = {
    useTmpfs = false; # this causes oom on kernel builds
    cleanOnBoot = true;
  };

  boot.initrd.systemd.enable = true;
  boot.crashDump.enable = true;

  boot.kernelParams = [
    # catppuccin latte as tty colors
    "vt.default_red=239,210,64,223,30,234,23,108,172,210,64,223,30,234,23,76"
    "vt.default_grn=241,15,160,142,102,118,146,111,176,15,160,142,102,118,146,79"
    "vt.default_blu=245,57,43,29,245,203,153,133,190,57,43,29,245,203,153,105"
  ];

  # copy and edit something because it is very annoying when ubuntu decide subjective things for
  # their users, and modprobe not having a !blacklist option.
  boot.modprobeConfig.useUbuntuModuleBlacklist = false;
  environment.etc."modprobe.d/ubuntu-edit.conf".source = ./ubuntu.modprobe.conf;

  time.timeZone = "Asia/Hong_Kong";

  # Lock root account
  users.users.root.shell = pkgs.shadow; # basically /bin/nologin
}
