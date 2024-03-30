{
  _utils,
  config,
  ...
}: let
  secrets = _utils.setupSecrets config {
    namespace = "grafana";
    secrets = [
      "oauth2/github/cid"
      "oauth2/github/cse"
      "oauth2/gateway/cid"
      "oauth2/gateway/cse"
    ];
    config = {
      owner = config.users.users.grafana.name;
    };
  };
  fromSecret = path: "$__file{${secrets.get path}}";
in {
  imports = [
    secrets.generate
    ./provisioning.nix
  ];

  users.users.grafana.extraGroups = [
    "nginx"
  ];

  services.grafana = {
    enable = true;
    settings = {
      server = {
        protocol = "socket";
        socket_gid = config.users.groups.nginx.gid;
        read_timeout = "1m";

        domain = "suika.soopy.moe";
        enforce_domain = true;

        root_url = "https://suika.soopy.moe/";
        router_logging = false;
      };

      security = {
        disable_initial_admin_creation = true;
        disable_gravatar = false;
        cookie_secure = true;
        cookie_samesite = "strict";
      };

      dashboards = {
        versions_to_keep = 5;
        min_refresh_interval = "30s";
      };

      users = {
        allow_sign_up = true;
        allow_org_create = false;
      };

      auth = {
        login_cookie_name = "girls_last_stats";
        disable_login_form = true;
      };

      "auth.github" = {
        enabled = true;
        allow_sign_up = false;
        client_id = fromSecret "oauth2/github/cid";
        client_secret = fromSecret "oauth2/github/cse";
        scopes = "user:email,read:org";
      };

      "auth.generic_oauth" = {
        name = "GensoGateway";
        enabled = true;

        allow_sign_up = true;

        client_id = fromSecret "oauth2/gateway/cid";
        client_secret = fromSecret "oauth2/gateway/cse";
        scopes = "openid email profile offline_access roles";

        email_attribute_path = "email";
        login_attribute_path = "username";
        name_attribute_path = "username";

        auth_url = "https://gateway.soopy.moe/realms/gensokyo/openid-connect/auth";
        token_url = "https://gateway.soopy.moe/realms/gensokyo/openid-connect/token";
        api_url = "https://gateway.soopy.moe/realms/gensokyo/openid-connect/userinfo";
      };
    };
  };

  services.nginx.virtualHosts."suika.soopy.moe" = _utils.mkSimpleProxy {
    socketPath = config.services.grafana.settings.server.socket;
    websockets = true;
  };
}
