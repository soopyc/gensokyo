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
      version = "2026.518.0-lazer";
      hash = "sha256-4LLNjrKEBS77LIbq+O6Xpxj6CvufGDApNqs61HN2JmA=";
      # nativeWayland = true; # this doesnt window properly
    })
  ];
}
