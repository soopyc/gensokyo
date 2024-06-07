{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.gensokyo.traits.games {
  environment.systemPackages = [
    pkgs.wineWowPackages.waylandFull
    pkgs.winetricks
  ];
}
