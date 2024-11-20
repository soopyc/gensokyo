{config, lib, ...}:
lib.mkIf config.gensokyo.traits.gui {
  services.xserver.desktopManager.gnome.enable = true;
}
