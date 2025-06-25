{
  traits,
  lib,
  pkgs,
  ...
}:
lib.mkIf traits.gui {
  home.packages = [
    pkgs.gimp3
    pkgs.krita
    pkgs.kdePackages.kdenlive
  ];
}
