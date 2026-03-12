{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gensokyo.caddy;
in
{
  options = {
    gensokyo.caddy.config = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "lines to become a proper caddyfile. works as you'd expect for a types.lines option.";
    };
  };

  config = lib.mkIf config.services.caddy.enable {
    services.caddy = {
      configFile = pkgs.writeText "Caddyfile" cfg.config;
      adapter = "caddyfile";
    };
  };
}
