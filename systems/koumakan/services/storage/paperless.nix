{
  lib,
  pkgs,
  config,
  inputs,
  _system,
  _utils,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    namespace = "paperless";
    secrets = [
      "secret_key"
      "oauth/gatekeeper/cid"
      "oauth/gatekeeper/cse"
    ];
  };

  allauthConfig = {
    openid_connect = {
      # this does not work at this moment.
      OAUTH_PKCS_ENABLED = true;
      SCOPE = [
        "openid"
        "email"
        "profile"
        "groups"
      ];
      APPS = lib.singleton {
        provider_id = "gatekeeper";
        name = "Gensokyo Gatekeeper";
        client_id = secrets.placeholder "oauth/gatekeeper/cid";
        secret = secrets.placeholder "oauth/gatekeeper/cse";
        settings = {
          server_url = "https://gatekeeper.soopy.moe";
          oauth_pkce_enabled = true; # this _also_ does not work??
        };
      };
    };
  };
in
{
  imports = [
    secrets.generate
    (secrets.mkTemplate "paperless.env" ''
      PAPERLESS_SOCIALACCOUNT_PROVIDERS='${builtins.toJSON allauthConfig}'
      PAPERLESS_SECRET_KEY='${secrets.placeholder "secret_key"}'
    '')
  ];

  gensokyo.ports = {
    paperless-ngx = 38411;
    tika = 37461;
    gotenberg = 34185;
  };
  services.gotenberg.port = config.gensokyo.ports.gotenberg;
  services.tika.port = config.gensokyo.ports.tika;

  users.users."paperless".extraGroups = lib.singleton "ftp-ingress";
  systemd.tmpfiles.settings = {
    "10-paperless" = lib.mkForce { }; # don't touch my shit
    "10-paperless-custom" =
      lib.genAttrs
        [
          config.services.paperless.dataDir
          config.services.paperless.mediaDir
        ]
        (_: {
          d = {
            user = config.services.paperless.user;
            group = config.users.users.${config.services.paperless.user}.name;
          };
        });
  };

  # TODO: another v3 migration: cannot override generation of _SECRET_KEY in the module... but everything else wants one
  systemd.services.paperless-web.script = lib.mkForce ''
    exec ${lib.getExe config.services.paperless.package.python.pkgs.granian} --interface asginl --ws "paperless.asgi:application"
  '';

  services.paperless = {
    enable = true;
    domain = "koakuma.soopy.moe";
    port = config.gensokyo.ports.paperless-ngx;
    database.createLocally = true;
    package = inputs.nixpkgs-unstable.legacyPackages.${_system}.paperless-ngx.overrideAttrs {
      # disable checks due to rebuilds and incomprehensibly slow build times
      # TODO: hopefully make upstream module/package use a wrapper instead
      doCheck = false;
      doInstallCheck = false;
    };
    environmentFile = secrets.getTemplate "paperless.env";

    consumptionDir = "/var/www/ftp/ingress";
    settings = {
      PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";

      PAPERLESS_ADVANCED_FUZZY_SEARCH_THRESHOLD = 0.5;
      PAPERLESS_OCR_LANGUAGE = "eng+chi_tra+chi_sim+jpn";
      PAPERLESS_DATE_PARSER_LANGUAGES = "en-HK+zh-Hant-HK+ja";

      PAPERLESS_ENABLE_COMPRESSION = false; # nginx does this already

      PAPERLESS_BIND_ADDR = "127.0.0.1";
      PAPERLESS_TRUSTED_PROXIES = "127.0.0.1";

      PAPERLESS_SOCIAL_AUTO_SIGNUP = true;
      PAPERLESS_SOCIAL_ACCOUNT_SYNC_GROUPS = true;
      PAPERLESS_SOCIAL_ACCOUNT_SYNC_SUPERUSER_GROUP = "admin";
      PAPERLESS_DISABLE_REGULAR_LOGIN = true;
      PAPERLESS_ACCOUNT_SESSION_REMEMBER = false;
      PAPERLESS_ACCOUNT_EMAIL_VERIFICATION = false;

      # TODO: setup email ingress

      PAPERLESS_THUMBNAIL_FONT_NAME = "${pkgs.lexend}/share/fonts/truetype/lexend/deca/LexendDeca-Regular.ttf";

      PAPERLESS_FILENAME_FORMAT = "{{ created_year }}-{{ created_month }}/{{ doc_pk }}-{{ asn }}";

      PAPERLESS_CONSUMPTION_DIR = "/var/www/ftp/ingress/";
      PAPERLESS_CONSUMER_ENABLE_BARCODES = true;
      PAPERLESS_CONSUMER_ENABLE_ASN_BARCODE = true;
      PAPERLESS_CONSUMER_ASN_BARCODE_PREFIX = "GSN";

      # TODO: pending 3.0 migrations
      PAPERLESS_DBENGINE = "postgresql";
      PAPERLESS_NLTK_DIR = "";
    };

    configureNginx = true;
    configureTika = true;

    exporter = {
      enable = true;
      onCalendar = "Sat 12:00";
    };
  };

  # most things already configured by ^ module, apply our own defaults with this
  services.nginx.virtualHosts."koakuma.soopy.moe" = _utils.mkVhost {
    # maybe don't archive potentially private stuff
    locations."= /robots.txt" = lib.mkForce (
      _utils.mkNginxFile {
        filename = "koakuma-robots.txt";
        content = ''
          User-Agent: *
          Disallow: /
        '';
      }
    );

    # hide djenga admin site
    locations."/admin".return = "444";
  };
}
