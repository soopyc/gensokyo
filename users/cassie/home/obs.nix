{
  pkgs,
  traits,
  lib,
  inputs,
  _system,
  ...
}:
lib.mkIf traits.gui {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-vaapi
      obs-vkcapture
      obs-pipewire-audio-capture
      inputs.nixpkgs-unstable.legacyPackages.${_system}.obs-studio-plugins.obs-wayland-hotkeys
    ];
  };

  home.packages = with pkgs; [ obs-cmd ];
}
