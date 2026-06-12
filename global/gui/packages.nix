{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  environment.systemPackages = with pkgs; [
    vlc
    mpv
    flameshot
    libnotify
    thunderbird
    ffmpeg-full
  ];
}
