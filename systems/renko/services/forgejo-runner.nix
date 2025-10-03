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
    package = pkgs.forgejo-forgejo-actions-runner;
    instances.default = {
      enable = true;
      name = "renko-default";
      url = "https://patchy.soopy.moe";
      tokenFile = secrets.get "tokenFile";
      labels = [
        "ubuntu-22.04:docker://node:20-bullseye"
      ];
    };
  };
}
