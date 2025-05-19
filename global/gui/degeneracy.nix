{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  environment.systemPackages = [
    pkgs.dosage-tracker

    (pkgs.discord.override {
      vencord = pkgs.vencord.overrideAttrs (_: prev: {
        version = "0-unstable+${inputs.vencord.shortRev}";
        src = inputs.vencord;
        env = prev.env // {
          VENCORD_REMOTE = "Vendicated/Vencord";
          VENCORD_HASH = inputs.vencord.shortRev;
        };
      });
      withVencord = true;
      withOpenASAR = true;
    })
  ];

  services.arrpc.enable = true;

  # this is in degeneracy because no one likes printers
  services.printing.enable = true;
}
