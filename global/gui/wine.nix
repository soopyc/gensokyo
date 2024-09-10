{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  environment.systemPackages = [
    pkgs.wineWowPackages.waylandFull
    pkgs.winetricks
  ];
}
