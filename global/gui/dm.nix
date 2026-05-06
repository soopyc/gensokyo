{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  services.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
    wayland.enable = true;
    # theme = "catppuccin-frappe";
  };

  environment.systemPackages = [
  #   (pkgs.catppuccin-sddm.override {
  #     flavor = "frappe";
  #   })
    (inputs.camasca.packages.${pkgs.stdenv.hostPlatform.system}.project-sekai-cursors.override {
      character = "Mizuki";
      animated = true;
    })
  ];
}
