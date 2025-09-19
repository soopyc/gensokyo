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
      version = "2025.912.0-lazer";
      hash = "sha256-73UY3RJp0pFfbxRWX8qSnLeoZB/BRGtucmQClJP7Qwg=";
      # nativeWayland = true; # this doesnt window properly
    })
  ];
}
