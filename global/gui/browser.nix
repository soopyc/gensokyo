{
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  programs.firefox = {
    enable = true;
    # package = pkgs.firefox-devedition;
  };
}
