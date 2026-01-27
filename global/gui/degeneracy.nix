{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  environment.systemPackages = with pkgs; [
    dosage-tracker
    signal-desktop
    (discord.override {
      withOpenASAR = true;
    })
    fractal
  ];

  # some things work better with flatpaks
  services.flatpak.enable = true;

  # this is in degeneracy because no one likes printers
  services.printing.enable = true;
}
