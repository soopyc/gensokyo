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

  # cache action communication
  networking.firewall.trustedInterfaces = [ "br-+" ];

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
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
