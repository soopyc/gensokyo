{
  _utils,
  pkgs,
  config,
  lib,
  ...
}: let
  mkRaw = (pkgs.formats.elixirConf {}).lib.mkRaw;
  # I don't know what i did but i made this abomination
  mkSecret = file:
    if !lib.elem file secrets
    then throw "Provided secret file ${file} is not in the list of defined secrets."
    else {_secret = config.sops.secrets."akkoma/${file}".path;};
  secrets = [
    "joken_default_signer" # can't think of any better name spacing
    "dist/cookie"
    "search/meili/host_unencrypted"
    "search/meili/key"
    "endpoint/secret_base"
    "endpoint/salt"
    "endpoint/live_view/salt"
    "vapid/pub"
    "vapid/key"
    "postgres/hostname"
    "postgres/username"
    "postgres/password"
    "smtp/username"
    "smtp/password"
    "smtp/relay"
  ];
in {
  # secrets definition
  sops.secrets = _utils.genSecrets "akkoma" secrets {
    owner = config.services.akkoma.user;
  }; # we probably don't need to set ownerships, but it's here for good measure

  services.akkoma = {
    enable = true;
    initSecrets = false;
    initDb.enable = false;

    dist.cookie = mkSecret "dist/cookie";
    config = {
      ":joken".":default_signer" = mkSecret "joken_default_signer";

      ":pleroma" = {
        ":http_security" = {
          sts = true;
        };

        ":configurable_from_database" = true;
        ":instance" = {
          name = "CassieAkko";
          description = "You should not see this here...";
          email = "me@soopy.moe";
          notify_email = "noreply@a.soopy.moe";
          limit = 5000;
          registrations_open = true;
        };

        # TODO: add proper proxy support
        # also refer to https://meta.akkoma.dev/t/another-vector-for-the-injection-vulnerability-found/483
        ":media_proxy" = {
          enabled = true;
          redirect_on_failure = true;
          base_url = "https://a-mproxy.soopy.moe/proxy";
        };

        "Pleroma.Repo" = {
          adapter = mkRaw "Ecto.Adapters.Postgres";
          database = "akkoma";
          hostname = mkSecret "postgres/hostname";
          username = mkSecret "postgres/username";
          password = mkSecret "postgres/password";
        };

        "Pleroma.Upload" = {
          base_url = "https://a-mproxy.soopy.moe/media";
          filters = [
            (mkRaw "Pleroma.Upload.Filter.Exiftool.StripMetadata")
            (mkRaw "Pleroma.Upload.Filter.Dedupe")
          ];
        };

        "Pleroma.Web.Endpoint" = {
          # We don't need to specify http ip/ports here because we use unix sockets
          # ok we do because it's broken
          http = {
            ip = "127.0.0.1";
            port = 35378;
          };
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
      locations."/proxy".return = "404";
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

  services.nginx = {
    appendHttpConfig = "proxy_cache_path /tmp/akkoma-media-cache levels=1:2 keys_zone=akkoma_media_cache:10m max_size=10g inactive=720m use_temp_path=off";
    virtualHosts."a-mproxy.soopy.moe" = _utils.mkVhost {
      locations."/proxy" = {
        proxyPass = "http://127.0.0.1:${builtins.toString config.services.akkoma.config.":pleroma"."Pleroma.Web.Endpoint".http.port}";
      };

      locations."/media/" = {
        tryFiles = "$uri =404";
        alias = config.services.akkoma.config.":pleroma".":instance".upload_dir + "/";
      };
    };
  };

  services.postgresql = {
    ensureDatabases = ["akkoma"];
    ensureUsers = [
      {
        name = "akkoma";
        ensureDBOwnership = true;
      }
    ];
  };

  # systemd.services.akkoma-config = {
  #   serviceConfig.SupplementaryGroups = [config.users.groups.keys.name];
  # };
  systemd.services.akkoma.serviceConfig = {
    Restart = "on-failure";
    RestartSec = "10s";
    RestartSteps = 5;
  };

  systemd.services.akkoma-config = {
    requiredBy = [
      "akkoma.service"
    ];
  };
}
