{
  _utils,
  pkgs,
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

  users.users.matrix-synapse.extraGroups = [config.users.groups.keys.name];

  services.matrix-synapse = {
    enable = true;
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
      # TODO: Setup TURN servers
      # TODO: Setup OIDC providers
      # TODO: Configure email
      # TODO: Setup opentracing
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

  services.postgresql = {
    ensureDatabases = ["synapse"];
    ensureUsers = [
      {
        name = "synapse";
        ensurePermissions = {
          "database \"synapse\"" = "all privileges";
        };
      }
    ];
  };

  services.nginx.virtualHosts."nue.soopy.moe" = _utils.mkVhost {
    locations."= /config.json" = {
      alias = "${pkgs.staticly}/configs/";
      tryFiles = "cinny.json =404";
      extraConfig = ''
        add_header access_control_allow_origin "*";
      '';
    };

    locations."~ ^(/_matrix|/_synapse/client)" = {
      proxyPass = "http://localhost:8080";
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
