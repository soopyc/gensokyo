{
  _utils,
  config,
  lib,
  pkgs,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    namespace = "forgejo";
    secrets = [ "tokenFile" ];
  };
in
{
  imports = lib.singleton secrets.generate;

  services.gitea-actions-runner = {
    package = pkgs.forgejo-actions-runner;
    instances.default = {
      enable = true;
      name = "renko-default";
      url = "https://patchy.soopy.moe";
      tokenFile = secrets.get "tokenFile";
      labels = [
        "debian-trixie:docker://node:24-trixie"
      ];
    };
  };
}
