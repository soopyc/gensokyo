{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  # other devices support modules

  hardware.keyboard.qmk.enable = true;
  environment.systemPackages = [
    pkgs.via
  ];

  programs.kdeconnect.enable = true;
}
