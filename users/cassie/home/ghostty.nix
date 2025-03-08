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

      minimum-contrast = 1.1;
    };
  };
}
