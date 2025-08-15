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
      version = "2025.813.0-tachyon";
      hash = "sha256-etZJEFXY0W9S7z5UvTywA5E636PaLJsqkzCKW/DF5Sg=";
      # nativeWayland = true; # this doesnt window properly
    })
  ];
}
