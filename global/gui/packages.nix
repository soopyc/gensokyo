{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  environment.systemPackages = with pkgs; [
    vlc
    flameshot
    libnotify
    thunderbird

    inputs.ghostty.packages.${pkgs.system}.default
  ];
}
