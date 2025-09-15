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
      version = "2025.905.0-tachyon";
      hash = "sha256-ApMGaKwHZ4I+1LFKzkF4kls9dRCLjYKBiJr82rBSYnU=";
      # nativeWayland = true; # this doesnt window properly
    })
  ];
}
