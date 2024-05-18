{
  pkgs,
  config,
  lib,
  ...
}:
# see https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
lib.mkIf config.gensokyo.traits.secure {
  environment.systemPackages = [pkgs.sbctl];

  # lanzaboote currently replaces systemd-boot, so disable that here.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
}
