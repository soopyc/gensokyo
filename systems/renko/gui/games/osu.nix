{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.gensokyo.traits.games {
  environment.systemPackages = [
    # this override is crap don't do it
    (pkgs.callPackage ./_osu.nix {
      version = "2026.305.0-lazer";
      hash = "sha256-azI3PS5LIVq1H02P1Z4Bny2VFqVLUC6pwCj1UD5HA6g=";
      # nativeWayland = true; # this doesnt window properly
    })
  ];
}
