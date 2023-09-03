{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    cryptsetup
    sbctl
  ];

  # lanzaboote currently replaces systemd-boot, so disable that here.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
}
