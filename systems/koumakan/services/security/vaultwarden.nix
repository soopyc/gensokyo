{
  _utils,
  config,
  # lib,
  ...
}:
let
  # mkSecrets = file:
  #   if !lib.elem file secrets
  #   then throw "Provided secret file ${file} is not in the list of defined secrets."
  #   else "/run/secrets/vaultwarden/${file}";
  secrets = [
    # TODO: figure out converting { smtp = ["username_encrypted"]; } to paths
    "admin_token"
    "smtp/username"
    "smtp/password"
    "smtp/host"
    "smtp/security"
    "smtp/port"
    "database/username"
    "database/password"
    "yubico/id"
    "yubico/secret"
    "push/installation_id"
    "push/installation_key"
  ];
in
{
  sops.secrets = _utils.genSecrets "vaultwarden" secrets { };
  sops.templates."vaultwarden.env".content =
    let
      ph = p: config.sops.placeholder."vaultwarden/${p}";
    in
    ''
      DATABASE_URL=postgresql://${ph "database/username"}:${ph "database/password"}@localhost/vaultwarden
      ADMIN_TOKEN=${ph "admin_token"}
      YUBICO_CLIENT_ID=${ph "yubico/id"}
      YUBICO_SECRET_KEY=${ph "yubico/secret"}
      SMTP_USERNAME=${ph "smtp/username"}
      SMTP_FROM=${ph "smtp/username"}
      SMTP_PASSWORD=${ph "smtp/password"}
      SMTP_HOST=${ph "smtp/host"}
      SMTP_SECURITY=${ph "smtp/security"}
      SMTP_PORT=${ph "smtp/port"}
      PUSH_INSTALLATION_ID=${ph "push/installation_id"}
      PUSH_INSTALLATION_KEY=${ph "push/installation_key"}
    '';

  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_ADDRESS = "::1";
      ROCKET_PORT = 38480;
      LOG_LEVEL = "warn";
      DOMAIN = "https://v.soopy.moe";
      IP_HEADER = "X-Real-IP";
      RELOAD_TEMPLATES = false;
      PUSH_ENABLED = true;

      SIGNUPS_ALLOWED = true;
      SIGNUPS_VERIFY = true;
      SIGNUPS_VERIFY_RESEND_TIME = 3600;
      SIGNUPS_VERIFY_RESEND_LIMIT = 6;
      INVITATIONS_ALLOWED = true;

      ICON_CACHE_TTL = 2592000;
      ICON_CACHE_NEGTTL = 7200;
      ICON_DOWNLOAD_TIMEOUT = 10;
      ICON_BLACKLIST_NON_GLOBAL_IPS = true;
      INVITATION_ORG_NAME = "TransGensokyobians";
      USER_ATTACHMENT_LIMIT = 100000;
      ORG_ATTACHMENT_LIMIT = 100000;

      DISABLE_2FA_REMEMBER = false;
      REQUIRE_DEVICE_EMAIL = true;
      PASSWORD_ITERATIONS = 1000000;
      PASSWORD_HINTS_ALLOWED = true;
      SHOW_PASSWORD_HINT = false;
      DISABLE_ADMIN_TOKEN = false;
      EMERGENCY_ACCESS_ALLOWED = true;
      EMAIL_TOKEN_SIZE = 12;
      LOGIN_RATELIMIT_SECONDS = 10;
      AUTHENTICATOR_DISABLE_TIME_DRIFT = false;

      SMTP_EMBED_IMAGES = true;
      SMTP_FROM_NAME = "Okuu (from vault at soopy.moe)";
      SMTP_TIMEOUT = 15;
      SMTP_ACCEPT_INVALID_CERTS = false;
      SMTP_ACCEPT_INVALID_HOSTNAMES = false;
    };
    dbBackend = "postgresql";
    environmentFile = config.sops.templates."vaultwarden.env".path;
  };

  services.nginx = {
    virtualHosts."v.soopy.moe" = _utils.mkVhost {
      extraConfig = ''
        client_max_body_size 100M;
        proxy_read_timeout 3h;
        proxy_connect_timeout 3h;
        proxy_send_timeout 3h;
      '';

      locations."/" = {
        proxyPass = "http://vault-default";
        proxyWebsockets = true; # in vw 1.30.0, the WS server is integrated into the same port.
      };
    };

    upstreams = {
      vault-default = {
        servers = {
          "[::1]:38480" = { };
        };
        extraConfig = ''
          zone vaultwarden 128k;  # XXX: are there any security implications if we reuse the same zone for both webvault and the ws server?
          keepalive 2;  # FIXME: should we use a higher keepalive?
        '';
      };
    };
  };
}
