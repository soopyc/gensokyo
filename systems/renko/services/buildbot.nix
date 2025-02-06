{_utils, config, lib, ...}: let
  secrets = _utils.setupSecrets config {
    namespace = "buildbot";
    secrets = lib.singleton "token";
  };
in {
  imports = lib.singleton secrets.generate;
  services.buildbot-nix.worker = {
    enable = true;
    masterUrl = "tcp:host=nijika:port=9989";
    workerPasswordFile = secrets.get "token";
  };
}
