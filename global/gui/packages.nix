{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  environment.systemPackages = [
    pkgs.vlc
    pkgs.thunderbird
    inputs.ghostty.packages.${pkgs.system}.default
  ];
}
