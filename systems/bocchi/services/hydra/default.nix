{
  _utils,
  config,
  lib,
  ...
}: let
  secrets = _utils.setupSecrets config {
    namespace = "hydra";
    secrets = [
      "s3"
      "signing_key/local"
      "signing_key/r2"
      "auth/gitea/cassie"
    ];
    config = {
      owner = config.users.users.hydra-www.name;
      group = config.users.users.hydra-www.group;
      mode = "0440";
    };
  };
in {
  imports = [
    secrets.generate

    (secrets.mkTemplate "hydra-auth.conf" ''
      <gitea_authorization>
        cassie = ${secrets.placeholder "auth/gitea/cassie"}
      </gitea_authorization>
    '')
  ];

  sops.secrets."hydra/s3" = {
    owner = lib.mkForce config.users.users.hydra-queue-runner.name;
    path = config.users.users.hydra-queue-runner.home + "/.aws/credentials";
  };
  sops.secrets.builder_key.owner = config.users.users.hydra-queue-runner.name;

  services.hydra-dev = {
    enable = true;
    # package = inputs.hydra.packages.${pkgs.system}.hydra;
    listenHost = "127.0.0.1";
    useSubstitutes = true;
    hydraURL = "https://hydra.soopy.moe";
    notificationSender = "hydra@services.soopy.moe";
    smtpHost = "mail.soopy.moe";

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
      # compress_build_logs 1
      #binary_cache_secret_key_file ${secrets.get "signing_key/local"} ## !! deprecated setting

      upload_logs_to_binary_cache = true
      store_uri = s3://nixos-cache?scheme=https&endpoint=2857eeff8794176be771f0e5567219f1.r2.cloudflarestorage.com&priority=50&compression=zstd&parallel-compression=true&write-nar-listing=true&ls-compression=br&log-compression=br&region=auto&want-mass-query=true&secret-key=${secrets.get "signing_key/r2"}

      <git-input>
        timeout = 1800
      </git-input>

      # Includes
      Include ${secrets.getTemplate "hydra-auth.conf"}
    '';
  };

  services.nginx.virtualHosts."hydra.soopy.moe" = _utils.mkSimpleProxy {
    port = 3000;
    extraConfig = {
      useACMEHost = "bocchi.c.soopy.moe";

      locations."= /pubkey" = {
        extraConfig = ''
          add_header content-type text/plain always;
        '';
        return = "200 hydra.soopy.moe:IZ/bZ1XO3IfGtq66g+C85fxU/61tgXLaJ2MlcGGXU8Q=";
      };
    };
  };
}
