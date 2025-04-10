{
  pkgs,
  config,
  lib,
  ...
}:
let
  types = lib.types;
  cfg = config.gensokyo.system-manager;
in
{
  options.gensokyo.system-manager = {
    enable = lib.mkEnableOption "a shortcut to manage the system no matter where you are (in the system)";
    flakeLocation = lib.mkOption {
      type = types.path;
      description = "The location of your system flake to manage.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.callPackage ./package.nix { inherit (cfg) flakeLocation; })
    ];
  };
}
