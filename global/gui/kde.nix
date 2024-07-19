{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  services.desktopManager.plasma6.enable = true;

  services.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
    wayland.enable = true;
  };

  environment.systemPackages = with pkgs.kdePackages; [
    kalk
    kdf
    kmime
    kasts
  ];
}
