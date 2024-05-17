{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  environment.systemPackages = [
    (pkgs.vesktop.override {
      withSystemVencord = false;
    })
    pkgs.zoom-us
  ];

  services.arrpc.enable = true;

  # this is in degeneracy because no one likes printers
  services.printing.enable = true;
}
