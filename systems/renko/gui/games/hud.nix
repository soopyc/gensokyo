{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.games {
  environment.systemPackages = [
    pkgs.mangohud
  ];
}
