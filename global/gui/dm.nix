{
  inputs,
  config,
  lib,
  _system,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  # services.displayManager.sddm = {
  #   enable = true;
  #   autoNumlock = true;
  #   wayland.enable = true;
  #   # theme = "catppuccin-frappe";
  # };

  services.displayManager.plasma-login-manager = {
    enable = true;
    # settings handled by kcm
  };

  environment.systemPackages = [
  #   (pkgs.catppuccin-sddm.override {
  #     flavor = "frappe";
  #   })
    (inputs.camasca.packages.${_system}.project-sekai-cursors.override {
      character = "Mizuki";
      animated = true;
    })
  ];
}
