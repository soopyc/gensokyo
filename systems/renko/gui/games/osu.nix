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
      version = "2026.119.0-lazer";
      hash = "sha256-lx8lU9tNXD90rpaKlIyR0C4eSivfmVAJP7Wq+n3Ht08=";
      # nativeWayland = true; # this doesnt window properly
    })
  ];
}
