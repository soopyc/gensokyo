{
  _utils,
  pkgs,
  lib,
  config,
  ...
}: let
  getSocket = file: "/run/matrix-synapse/${file}.sock";
in {
  sops.secrets."synapse.yaml" = {
    mode = "0400";
    owner = config.users.users.matrix-synapse.name;
  };

  sops.secrets.matrix-signing-key = {
    mode = "0400";
    owner = config.users.users.matrix-synapse.name;
  };

  users.users.matrix-synapse.shell = lib.mkForce pkgs.shadow;

  services.matrix-synapse = {
    enable = true;
    enableRegistrationScript = false;
    configureRedisLocally = true; # workers support

    withJemalloc = true;
    extras = [
      "jwt"
      "oidc"
    ];

    extraConfigFiles = [
      "/run/secrets/synapse.yaml"
    ];

    workers = {
      federation-sender-0 = {};
      pusher-0 = {};
    };

    settings = {
      server_name = "nue.soopy.moe";
      serve_server_wellknown = true;
      allow_public_rooms_over_federation = true;
      federation_client_minimum_tls_version = 1.2;

      listeners = [
        {
          path = getSocket "mistress";
          resources = [
            {
              names = [
                "client" # implies ["media" "static"]
                "federation"
                "keys"
                "openid"
                "replication"
              ];
            }
          ];
        }
      ];

      # workers
      instance_map.main.path = getSocket "mistress";
      federation_sender_instances = [
        "federation-sender-0"
      ];
      pusher_instances = [
        "pusher-0"
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

      allow_device_name_lookup_over_federation = true;

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

  services.postgresql = {
    ensureDatabases = ["synapse"];
    ensureUsers = [
      {
        name = "synapse";
        ensureDBOwnership = true;
      }
    ];
  };

  users.users.nginx.extraGroups = ["matrix-synapse"];
  services.nginx.virtualHosts."nue.soopy.moe" = _utils.mkVhost {
    extraConfig = ''
      access_log off;
    '';

    locations."= /.well-known/matrix/server" = _utils.mkNginxJSON "server" {
      "m.server" = "nue.soopy.moe:443";
    };

    locations."~ ^(/_matrix|/_synapse/client|/health)" = {
      proxyPass = "http://unix:${getSocket "mistress"}";
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
