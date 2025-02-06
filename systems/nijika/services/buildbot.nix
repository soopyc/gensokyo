{
  _utils,
  lib,
  config,
  ...
}: let
  secrets = _utils.setupSecrets config {
    namespace = "buildbot";
    secrets = [
      "gh/private_key"
      "gh/webhook_secret"
      "gitea/token"
      "gitea/client_secret"
      "gitea/webhook_secret"

      "workers/renko"
    ];
  };
  mkWorker = name: cores: {
    inherit name cores;
    pass = secrets.placeholder "workers/${name}";
  };
in {
  imports = [
    secrets.generate
    (secrets.mkTemplate "buildbot.workers.json" (builtins.toJSON [
      (mkWorker "renko" 12)
    ]))
  ];

  services.buildbot-nix.master = {
    enable = true;
    domain = "ci.soopy.moe";
    useHTTPS = true;
    admins = ["soopyc"];
    accessMode.public = {};
    workersFile = secrets.getTemplate "buildbot.workers.json";

    # forges configuration
    authBackend = "gitea";
    github = {
      enable = true;
      webhookSecretFile = secrets.get "gh/webhook_secret";
      authType.app = {
        id = 1135740;
        secretKeyFile = secrets.get "gh/private_key";
      };
    };
    gitea = {
      enable = true;
      tokenFile = secrets.get "gitea/token";
      webhookSecretFile = secrets.get "gitea/webhook_secret";
      instanceUrl = "https://patchy.soopy.moe";
      oauthId = "4c9061a1-2ec9-42bb-a80c-8f3124f13b29";
      oauthSecretFile = secrets.get "gitea/client_secret";
    };
  };

  services.nginx.virtualHosts.${config.services.buildbot-nix.master.domain} = _utils.mkVhost {
    useACMEHost = lib.mkForce null;
    enableACME = true;
  };
}
