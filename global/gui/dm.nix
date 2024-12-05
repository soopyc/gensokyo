{
  config,
  lib,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  services.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
    wayland.enable = true;
  };
}
