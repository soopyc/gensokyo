{
  inputs,
  traits,
  lib,
  pkgs,
  ...
}:
lib.mkIf traits.gui {
  programs.ghostty = {
    enable = true;
    package = inputs.ghostty.packages.${pkgs.system}.ghostty;
    settings = {
      theme = "catppuccin-latte";
      font-family = "CozetteVector";
      font-size = 14;
      window-decoration = "client";

      # great feature, but breaks a bit too many things :(
      # minimum-contrast = 1.1;
      async-backend = "epoll"; # see if this fixes iowait "bug"

      custom-shader = builtins.toString ./assets/cursor_smear.glsl;
      custom-shader-animation = true;
    };
  };
}
