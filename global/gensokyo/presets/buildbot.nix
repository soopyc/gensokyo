{
  _utils,
  config,
  lib,
  ...
}: let
  secrets = _utils.setupSecrets config {
    namespace = "buildbot";
    secrets = lib.singleton "token";
  };
in
  lib.mkIf config.gensokyo.presets.buildbot (lib.mkMerge [
    {
      services.buildbot-nix.worker = {
        enable = true;
        masterUrl = "tcp:host=koumakan:port=9989";
        workerPasswordFile = secrets.get "token";
      };
    }
    secrets.generate
  ])
