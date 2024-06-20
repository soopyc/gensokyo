{
  pkgs,
  traits,
  lib,
  ...
}: {
  home.packages = lib.mkIf traits.gui [
    pkgs.wl-clipboard
    # pkgs.logseq
  ];
}
