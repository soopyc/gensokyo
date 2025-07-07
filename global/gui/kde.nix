{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs.kdePackages; [
    qtmultimedia # this fixes something but i forgot what

    kalk
    kdf
    kmime
  ];
}
