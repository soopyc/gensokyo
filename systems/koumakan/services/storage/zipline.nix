{
  _utils,
  lib,
  config,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    namespace = "zipline";
    secrets = [
      "core/secret"
      "s3/access_key"
      "s3/access_secret"
    ];
  };

  oidcOp = "https://gatekeeper.soopy.moe";
in
{
  imports = [
    secrets.generate
    (secrets.mkTemplate "zipline.env" ''
      CORE_SECRET=${secrets.placeholder "core/secret"}
      DATASOURCE_S3_ACCESS_KEY_ID=${secrets.placeholder "s3/access_key"}
      DATASOURCE_S3_SECRET_ACCESS_KEY=${secrets.placeholder "s3/access_secret"}
    '')
  ];

  services.zipline = {
    enable = true;
    environmentFiles = lib.singleton (secrets.getTemplate "zipline.env");

    settings = {
      CORE_PORT = 34638;
      CORE_RETURN_HTTPS_URLS = "true";
      CORE_DEFAULT_DOMAIN = "dumpster.soopy.moe";
      CORE_TRUST_PROXY = "true";
      CORE_TEMP_DIRECTORY = "/tmp/zipline"; # should auto-create on startup

      DATASOURCE_TYPE = "s3";
      DATASOURCE_S3_BUCKET = "zipline";
      DATASOURCE_S3_REGION = "ap-east-1";
      DATASOURCE_S3_ENDPOINT = "https://s3.soopy.moe";
      DATASOURCE_S3_FORCE_PATH_STYLE = "true";

      MFA_PASSKEYS_ENABLED = "true";
      MFA_PASSKEYS_RP_ID = "dumpster.soopy.moe";
      MFA_PASSKEYS_ORIGIN = "https://dumpster.soopy.moe";

      CHUNKS_ENABLED = "true";
      CHUNKS_MAX = "95mb";
      CHUNKS_SIZE = "25mb";

      OAUTH_OIDC_CLIENT_ID = "478bc046-4ff4-4630-bec8-6e9f03f61e7e";
      OAUTH_OIDC_AUTHORIZE_URL = "${oidcOp}/authorize";
      OAUTH_OIDC_TOKEN_URL = "${oidcOp}/api/oidc/token";
      OAUTH_OIDC_USERINFO_URL = "${oidcOp}/api/oidc/userinfo";

      FILES_ROUTE = "/";
      FILES_LENGTH = 12;
      FILES_MAX_FILES_PER_UPLOAD = 1000;
      FILES_MAX_FILE_SIZE = "10gb";
      FILES_ASSUME_MIMETYPES = "true"; # confusingly enables "guessing" or "sniffing" the mimetype instead of trusting the client: https://zipline.diced.sh/docs/config/settings#files
      FILES_DEFAULT_COMPRESSION_FORMAT = "webp";
      FILES_REMOVE_GPS_METADATA = "true";
      FILES_RANDOM_WORDS_NUM_ADJECTIVES = 5;

      INVITES_ENABLED = "true";
      INVITES_LENGTH = 32;

      RATELIMIT_ENABLED = "true";
      RATELIMIT_MAX = 5;
      RATELIMIT_WINDOW = 30;
      RATELIMIT_ADMIN_BYPASS = "false";

      WEBSITE_TITLE = "dumpsterfile";
      WEBSITE_TITLE_LOGO = "https://assets.soopy.moe/images/wastebasket.png";
      WEBSITE_THEME_DARK = "builtin:catppuccin_mocha";
      WEBSITE_THEME_LIGHT = "builtin:catppuccin_latte";
    }
    // (lib.mapAttrs'
      (k: v: (lib.nameValuePair "FEATURES_${lib.toUpper k}" (lib.generators.mkValueStringDefault { } v)))
      {
        user_registration = false; # via invites
        image_compression = true;
        oauth_registration = true;
        robots_txt = false;
        thumbnails_enabled = true;
        thumbnails_num_threads = 4;
        thumbnails_format = "webp";
        thumbnails_instantaneous = true;
        metrics_enabled = true;
      }
    );
  };

  services.nginx.virtualHosts."dumpster.soopy.moe" = _utils.mkSimpleProxy {
    port = 34638;
    extraConfig.extraConfig = ''
      client_max_body_size 100M;
    '';
  };

  systemd.services.zipline.serviceConfig = {
    Restart = "on-failure";
    # RestartSec = "10s";
  };
}
