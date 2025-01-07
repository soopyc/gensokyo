{
  traits,
  lib,
  pkgs,
  ...
}:
lib.mkIf traits.gui {
  home.packages = [
    pkgs.gimp
    pkgs.kdePackages.kdenlive
  ];
}
