{
  lib,
  config,
  pkgs-unstable,
  ...
}:
lib.mkIf config.gensokyo.traits.gui (
  let
    package = pkgs-unstable.ghostty;
  in
  {
    systemd = {
      packages = lib.singleton package;

      user.services."app-com.mitchellh.ghostty" = {
        restartIfChanged = false;
        overrideStrategy = "asDropin";

        # don't set other junk
        environment = lib.genAttrs [ "PATH" "LOCALE_ARCHIVE" "TZDIR" ] (_: lib.mkForce null);
      };
    };

    services.dbus.packages = lib.singleton package;
    environment.systemPackages = lib.singleton package;
  }
)
