{
  lib,
  config,
  inputs,
  _system,
  ...
}:
lib.mkIf config.gensokyo.traits.gui (
  let
    package = inputs.ghostty.packages.${_system}.default;
  in
  {
    systemd = {
      packages = lib.singleton package;

      user.services."app-com.mitchellh.ghostty" = {
        restartIfChanged = false;
        overrideStrategy = "asDropin";
      };
    };

    services.dbus.packages = lib.singleton package;
    environment.systemPackages = lib.singleton package;
  }
)
