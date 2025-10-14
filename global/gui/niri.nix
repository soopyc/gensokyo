{ lib, config, ... }:
lib.mkIf config.gensokyo.traits.gui {
  programs.niri.enable = true;
}
