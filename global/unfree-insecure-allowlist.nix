{ lib, ... }:
{
  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      # builtins.trace "package ${lib.getName pkg} (${pkg.name or pkg.pname}) queried" true; # temporary
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-unwrapped"
        "osu-lazer-bin"
        "idea"
        "discord"
        "via"

        "brcm-mac-firmware-zstd"
      ];

    allowInsecurePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "olm"
      ];
  };
}
