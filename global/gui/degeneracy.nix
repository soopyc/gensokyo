{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  environment.systemPackages = [
    pkgs.dosage-tracker
    pkgs.signal-desktop
    (pkgs.discord.override {
      withOpenASAR = true;
    })
  ];

  # this is in degeneracy because no one likes printers
  services.printing.enable = true;
}
