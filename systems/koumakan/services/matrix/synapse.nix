{
  _utils,
  pkgs,
  lib,
  config,
  ...
}: {
  sops.secrets."synapse.yaml" = {
    mode = "0400";
    owner = config.users.users.matrix-synapse.name;
  };

  sops.secrets.matrix-signing-key = {
    mode = "0400";
    owner = config.users.users.matrix-synapse.name;
  };

  sops.secrets."matrix-sliding-sync/db_pass" = {};
  sops.secrets."matrix-sliding-sync/secret" = {};
  sops.templates."matrix-sliding-sync-env".content = ''
    SYNCV3_DB="host=localhost port=5432 dbname=matrix-sliding-sync password=${config.sops.placeholder."matrix-sliding-sync/db_pass"}"
    SYNCV3_SECRET=${config.sops.placeholder."matrix-sliding-sync/secret"}
  '';

  users.users.matrix-synapse.shell = lib.mkForce pkgs.shadow;

  services.matrix-synapse = {
    enable = true;
    enableRegistrationScript = false;
    
    withJemalloc = true;
    extras = [
      "jwt"
      "oidc"
    ];

    extraConfigFiles = [
      "/run/secrets/synapse.yaml"
    ];

    settings = {
      server_name = "nue.soopy.moe";
      serve_server_wellknown = true;
      allow_public_rooms_over_federation = true;
      federation_client_minimum_tls_version = 1.2;

      listeners = [
        {
          path = "/run/matrix-synapse/synapse.sock";
          resources = [
            {
              names = [
                "client" # implies ["media" "static"]
                "consent"
                "federation"
                "keys"
                "openid"
                "replication"
              ];
            }
          ];
        }
      ];

      # TODO: Setup TURN servers
      # TODO: Setup OIDC providers
      # TODO: Configure email
      url_preview_enabled = true;
      enable_registration = false;
      session_lifetime = "99y";

      max_upload_size = "100M";
      signing_key_path = "/run/secrets/matrix-signing-key";

      server_notices = {
        system_mxid_localpart = "server";
        system_mxid_display_name = "Server Notices";
        room_name = "Server Notices";
      };

      trusted_key_servers = [
        {
          server_name = "matrix.org";
          verify_keys = {
            "ed25519:auto" = "Noi6WqcDj0QmPxCNQqgezwTlBKrfqehY1u2FyWP9uYw";
          };
        }
        {
          server_name = "m.lea.moe";
        }
      ];

      password_config = {
        policy = {
          enabled = true;
          minimum_length = 12;
        };
      };
    };
  };

  services.matrix-sliding-sync = {
    enable = true;
    createDatabase = true; # let the module handle itself
    settings = {
      SYNCV3_SERVER = "https://${config.services.matrix-synapse.settings.server_name}";
      SYNCV3_BINDADDR = "[::1]:12723";
      SYNCV3_DB = lib.mkForce "";
    };
    environmentFile = config.sops.templates."matrix-sliding-sync-env".path;
  };

  services.postgresql = {
    ensureDatabases = ["synapse"];
    ensureUsers = [
      {
        name = "synapse";
        ensureDBOwnership = true;
      }
    ];
  };

  services.nginx.virtualHosts."sliding.proxy.production.matrix.soopy.moe" = _utils.mkSimpleProxy {
    port = 12723;
    extraConfig = {
      useACMEHost = "proxy.c.soopy.moe";

      locations."= /" = _utils.mkNginxFile {
        content = ''<!doctype html><html><head><title>msc3575 proxy</title><style>html{font-family:monospace;}</style></head><body><h2>Welcome to the sliding sync proxy.</h2><p>This proxy is for internal use only, you will need an account on nue.soopy.moe to use it. Feel free to self host one yourself!!</p></body></html>'';
      };
    };
  };

  users.users.nginx.extraGroups = ["matrix-synapse"];
  services.nginx.virtualHosts."nue.soopy.moe" = _utils.mkVhost {
    locations."= /.well-known/matrix/server" = _utils.mkNginxJSON "server" {
      "m.server" = "nue.soopy.moe:443";
    };

    locations."~ ^(/_matrix|/_synapse/client)" = {
      proxyPass = "http://unix:/run/matrix-synapse/synapse.sock";
      extraConfig = ''
        client_max_body_size 100M;
      '';
    };

    locations."= /.well-known/matrix/client" = {
      alias = "${pkgs.staticly}/configs/matrix/";
      tryFiles = "stable.json =404";
    };

    locations."/" = {
      root = "${pkgs.staticly}/pages/matrix/landing/";
      tryFiles = "$uri $uri/index.html $uri.html =404";
    };
  };
}
