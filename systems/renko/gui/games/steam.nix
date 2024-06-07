{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.games {
  programs.steam = {
    enable = true;

    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];

    protontricks.enable = true;
  };
}
