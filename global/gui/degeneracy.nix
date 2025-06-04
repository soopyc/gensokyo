{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  environment.systemPackages = [
    pkgs.dosage-tracker
    pkgs.dorion
  ];

  # this is in degeneracy because no one likes printers
  services.printing.enable = true;
}
