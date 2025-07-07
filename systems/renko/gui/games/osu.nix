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
      version = "2025.702.0-tachyon";
      hash = "sha256-qlL6SZRITpTzur96Ge4AZmxH5pnd6tnuDIm6enppVu4=";
      # nativeWayland = true; # this doesnt window properly
    })
  ];
}
