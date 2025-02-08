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
      font-size = if traits.hidpi then 20 else 10;
      window-decoration = "client";
    };
  };
}
