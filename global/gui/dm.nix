{config, lib, ...}:
lib.mkIf config.gensokyo.traits.gui {
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
    };
  };

  # services.displayManager.sddm = {
  #   enable = true;
  #   autoNumlock = true;
  #   wayland.enable = true;
  # };
}
