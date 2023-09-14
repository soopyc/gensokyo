{
  _utils,
  pkgs,
  config,
  lib,
  ...
}: let
  mkRaw = (pkgs.formats.elixirConf {}).lib.mkRaw;
  # I don't know what i did but i made this abomination
  genSecrets = namespace: files: value: lib.genAttrs (map (x: namespace + x) files) (_: value);
  mkSecret = file:
    if !lib.elem file secrets
    then throw "Provided secret file ${file} is not in the list of defined secrets."
    else {_secret = "/run/secrets/akkoma/${file}";};
  secrets = [
    "joken_default_signer" # can't think of any better name spacing
    "search/meili/host_unencrypted"
    "search/meili/key"
    "endpoint/secret_base"
    "endpoint/salt"
    "endpoint/live_view/salt"
    "vapid/pub"
    "vapid/key"
    "postgres/hostname"
    "postgres/database_unencrypted"
    "postgres/username"
    "postgres/password"
    "smtp/username"
    "smtp/password"
    "smtp/relay"
  ];
in {
  # secrets definition
  sops.secrets = genSecrets "akkoma/" secrets {};

  services.akkoma = {
    enable = true;
    initSecrets = false;
    initDb.enable = false;
    # TODO: figure out how to add swagger ui
    # frontends = {
    #   swagger
    # };
    config = {
      ":joken".":default_signer" = mkSecret "joken_default_signer";

      ":pleroma" = {
        ":http_security" = {
          sts = true;
        };

        "configurable_from_database" = true;
        ":instance" = {
          name = "CassieAkko";
          description = "You should not see this here...";
          email = "me@soopy.moe";
          notify_email = "noreply@a.soopy.moe";
          limit = 5000;
          registrations_open = true;
        };

        ":media_proxy" = {
          enabled = true;
          redirect_on_failure = true;
        };

        "Pleroma.Repo" = {
          adapter = mkRaw "Ecto.Adapters.Postgres";
          database = mkSecret "postgres/database_unencrypted";
          hostname = mkSecret "postgres/hostname";
          username = mkSecret "postgres/username";
          password = mkSecret "postgres/password";
        };

        "Pleroma.Upload" = {
          filters = [
            (mkRaw "Pleroma.Upload.Filter.Exiftool")
            (mkRaw "Pleroma.Upload.Filter.Dedupe")
          ];
        };

        "Pleroma.Web.Endpoint" = {
          # We don't need to specify http ip/ports here because we use unix sockets
          url = {
            host = "a.soopy.moe";
            scheme = "https";
            port = 443;
          };
          secure_cookie_flag = true;

          secret_key_base = mkSecret "endpoint/secret_base";
          signing_salt = mkSecret "endpoint/salt";
          live_view = {
            signing_salt = mkSecret "endpoint/live_view/salt";
          };
        };

        "Pleroma.Emails.Mailer" = {
          adapter = mkRaw "Swoosh.Adapters.SMTP";
          relay = mkSecret "smtp/relay";
          username = mkSecret "smtp/username";
          password = mkSecret "smtp/password";
        };

        "Pleroma.Search.Meilisearch" = {
          url = mkSecret "search/meili/host_unencrypted";
          private_key = mkSecret "search/meili/key";
          initial_indexing_chunk_size = 100000;
        };
      };

      ":web_push_encryption".":vapid_details" = {
        subject = "mailto:me@soopy.moe";
        public_key = mkSecret "vapid/pub";
        private_key = mkSecret "vapid/key";
      };
    };

    nginx = _utils.mkVhost {
      useACMEHost = "fedi.c.soopy.moe";
      extraConfig = ''
        client_max_body_size 100M;
      '';
    };

    extraStatic = {
      "static/terms-of-service.html" = pkgs.writeText "terms-of-service.html" ''
        <h1>Terms of Service</h1><p>Please refer to this ToS:
        <a href="https://m.soopy.moe/@admin/pages/tos" rel="noopener noreferrer nofollow">
        https://m.soopy.moe/@admin/pages/tos</a></p>
      '';
      # refer to https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/servers/akkoma/emoji/blobs_gg.nix#L29
      # "emoji/Cat_girls_Emoji" = ...
    };
  };

  systemd.services.akkoma-config = {
    serviceConfig.SupplementaryGroups = [config.users.groups.keys.name];
  };
}
