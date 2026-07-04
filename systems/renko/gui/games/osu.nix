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
      version = "2026.624.0-lazer";
      hash = "sha256-EKmCq656djPGK5I1JqSDcTKtpbQZbO8WGWcPv+PT0q4=";
      # nativeWayland = true; # this doesnt window properly
    })
  ];
}
