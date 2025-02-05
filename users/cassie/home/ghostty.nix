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
      font-family = "Hurmit Nerd Font";
      font-size = 10;
      window-decoration = "client";
    };
  };
}
