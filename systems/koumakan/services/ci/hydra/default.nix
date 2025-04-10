{
  inputs,
  pkgs,
  _utils,
  config,
  lib,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    namespace = "hydra";
    secrets = [
      "s3/key_id"
      "s3/key_secret"
      "signing_key/v1"
    ];
    config = {
      owner = config.users.users.hydra-www.name;
      group = config.users.users.hydra-www.group;
      mode = "0440";
    };
  };

  webhookScript = pkgs.writeShellApplication {
    name = "hydra-webhook";
    runtimeInputs = with pkgs; [ xh ];
    text = ''
      xh :8000 @"$1"
    '';
  };
in
{
  imports = [
    secrets.generate
    (secrets.mkTemplate "hydra-s3-creds" ''
      [default]
      aws_access_key_id = ${secrets.placeholder "s3/key_id"}
      aws_secret_access_key = ${secrets.placeholder "s3/key_secret"}
    '')
  ];

  sops.templates."hydra-s3-creds" = {
    owner = lib.mkForce config.users.users.hydra-queue-runner.name;
    path = config.users.users.hydra-queue-runner.home + "/.aws/credentials";
  };
  sops.secrets.builder_key.owner = config.users.users.hydra-queue-runner.name;

  services.hydra-dev = {
    enable = true;
    package = inputs.hydra.packages.${pkgs.system}.hydra;

    listenHost = "127.0.0.1";
    hydraURL = "https://hydra.soopy.moe";

    useSubstitutes = true;
    notificationSender = "hydra+noreply@services.soopy.moe";

    logo = ./hydra.png;
    # wow so tracker
    tracker = ''
      <link rel="icon" type="image/png" href="/logo" />
      <style>
        .logo {
          margin-top: unset !important;
        }
      </style>
    '';

    extraConfig = ''
      # conflicts with upload_logs_to_binary_cache
      # compress_build_logs 1

      max_output_size = 5368709120 # 5 << 30 (5 GiB)
      upload_logs_to_binary_cache = true
      store_uri = s3://nix-cache?scheme=https&endpoint=s3.soopy.moe&compression=zstd&parallel-compression=true&write-nar-listing=true&ls-compression=br&log-compression=br&region=ap-east-1&secret-key=${secrets.get "signing_key/v1"}

      binary_cache_public_uri = https://cache.soopy.moe
      log_prefix = https://cache.soopy.moe/

      <git-input>
        timeout = 1800
      </git-input>

      # ad hoc webhook
      <runcommand>
        job = *:*:*
        #command = ${webhookScript} $HYDRA_JSON
        command = cat $HYDRA_JSON >> /tmp/hydra-notify-runcommand.json
      </runcommand>
    '';
  };

  services.nginx.virtualHosts."hydra.soopy.moe" = _utils.mkSimpleProxy {
    port = 3000;
    extraConfig = {
      locations."/metrics" = {
        return = "444";
      };
    };
  };
}
