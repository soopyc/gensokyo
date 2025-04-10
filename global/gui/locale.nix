{
  config,
  lib,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  i18n.supportedLocales = [ "all" ];
}
