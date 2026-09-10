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
    package = inputs.nixpkgs-unstable.legacyPackages.${_system}.obs-studio;
    plugins = with inputs.nixpkgs-unstable.legacyPackages.${_system}.obs-studio-plugins; [
      obs-vaapi
      obs-vkcapture
      obs-pipewire-audio-capture
      obs-wayland-hotkeys
    ];
  };

  home.packages = with pkgs; [ obs-cmd ];
}
