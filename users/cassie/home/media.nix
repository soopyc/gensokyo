{
  traits,
  lib,
  pkgs,
  ...
}:
lib.mkIf traits.gui {
  home.packages = [
    pkgs.gimp-with-plugins
    pkgs.kdePackages.kdenlive
  ];
}
