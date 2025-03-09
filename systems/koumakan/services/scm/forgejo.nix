{
  _utils,
  lib,
  config,
  pkgs,
  ...
}: let
  secrets = [
    "database/pass"
    "turnstile/secret"
    "turnstile/sitekey"
    "mailing/host"
    "mailing/protocol"
    "mailing/from"
    "mailing/user"
    "mailing/pass"
  ];
  ns = "forgejo";
  mkSecret = file: config.sops.secrets."${ns}/${file}".path;
  # mkSecret = file:
  #   if !lib.elem file secrets
  #   then throw "Could not find requested secret ${file} in definition."
  #   else "/run/secrets/${ns}";

  runConfig = config.services.forgejo.customDir + "/conf/app.ini";
in {
  sops.secrets = _utils.genSecrets ns secrets {
    owner = config.services.forgejo.user;
  };
  services.forgejo = {
    enable = true;
    package = pkgs.forgejo;

    repositoryRoot = "${config.services.forgejo.stateDir}/data/repositories";

    secrets = {
      service = {
        CF_TURNSTILE_SECRET = mkSecret "turnstile/secret";
        CF_TURNSTILE_SITEKEY = mkSecret "turnstile/sitekey";
      };

      mailer = {
        PROTOCOL = mkSecret "mailing/protocol";
        SMTP_ADDR = mkSecret "mailing/host";
        FROM = mkSecret "mailing/from";
        USER = mkSecret "mailing/user";
        PASSWD = mkSecret "mailing/pass";
      };
    };

    settings = {
      DEFAULT.APP_NAME = "Patchy";
      server = {
        # Basic settings {{{
        # PROTOCOL = "http+unix"; # anubis ATM requires tcp sockets
        PROTOCOL = "http";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 33421;
        DOMAIN = "patchy.soopy.moe";
        ROOT_URL = "https://patchy.soopy.moe";
        OFFLINE_MODE = false;
        # HTTP_ADDR is defined automatically.
        # }}}

        # SSH {{{
        DISABLE_SSH = false; # don't disable ssh access
        START_SSH_SERVER = false; # do disable the built-in ssh server.
        SSH_DOMAIN = "patchy.soopy.moe";
        SSH_PORT = 22;
        SSH_CREATE_AUTHORIZED_KEY_FILE = false;
        SSH_CREATE_AUTHORIZED_PRINCIPALS_FILE = false;
        # }}}
      };

      # Indexer {{{
      indexer = {
        REPO_INDEXER_ENABLED = true; # good bye hdd health
        REPO_INDEXER_REPO_TYPES = "sources,forks,templates";
      };
      # }}}

      # Service {{{
      service = {
        ENABLE_NOTIFY_MAIL = true;
        REGISTER_EMAIL_CONFIRM = true;

        DISABLE_REGISTRATION = false;
        ALLOW_ONLY_EXTERNAL_REGISTRATION = true;

        ENABLE_CAPTCHA = true;
        CAPTCHA_TYPE = "cfturnstile";
      };
      # }}}

      # Mailing {{{
      mailer = {
        ENABLED = true;
        SEND_AS_PLAIN_TEXT = true;
      };
      # }}}

      # Repository related {{{
      repository = {
        DEFAULT_PUSH_CREATE_PRIVATE = false;
        ENABLE_PUSH_CREATE_USER = true;
        ENABLE_PUSH_CREATE_ORG = true;
      };
      "repository.upload" = {
        ENABLED = true;
        FILE_MAX_SIZE = 10;
        MAX_FILES = 10;
      };
      "repository.signing" = {
        DEFAULT_TRUST_MODEL = "committer";
      };
      "repository.pull-request" = {
        WORK_IN_PROGRESS_PREFIXES = "WIP:,[WIP],draft:";
        DEFAULT_MERGE_STYLE = "rebase-merge";
      };
      # }}}

      # Web UI {{{
      "ui.meta" = {
        AUTHOR = "Patchy";
        DESCRIPTION = "Patchouli Knowledge, holder of code repos";
      };
      "ui.svg" = {
        ENABLE_RENDER = true;
      };
      # }}}

      # Security {{{
      security = {
        # Other relavant settings are defined automatically.
        PASSWORD_HASH_ALGO = "argon2";
        COOKIE_USERNAME = "I_LOVE_FORGEJO";
        COOKIE_REMEMBER = "I_HATE_GITHUB";
        REVERSE_PROXY_TRUSTED_PROXIES = "127.0.0.1/8,::1/128";
        MIN_PASSWORD_LENGTH = 8;
        PASSWORD_COMPLEXITY = "lower,digit";
        PASSWORD_CHECK_PWN = true;
      };
      # }}}

      # OAuth 2.0 and OpenID {{{
      oauth2 = {
        # JWT_SECRET defined automatically, but we don't use it lol
        ENABLED = true;
        JWT_SIGNING_ALGORITHM = "EdDSA";
        JWT_SIGNING_PRIVATE_KEY_FILE = "jwt/oauth.pem";
        # to generate, we're using: nix run n#openssl -- genpkey -algorithm ed25519 -out /var/lib/forgejo/data/jwt/oauth.pem
      };

      oauth2_client = {
        REGISTER_EMAIL_CONFIRM = false;
      };

      openid = {
        ENABLE_OPENID_SIGNIN = false;
        ENABLE_OPENID_SIGNUP = false;
      };
      # }}}

      # TODO: setup go-camo

      # Logging {{{
      log = {
        ROOT_PATH = "/var/log/forgejo/";
        "logger.router.MODE" = "";
      };
      # }}}

      # Federation {{{
      federation = {
        ENABLED = true;
        MAX_SIZE = 10;
      };
      # }}}

      # Session {{{
      session = {
        PROVIDER = "db"; # reuse existing db config
        COOKIE_SECURE = true;
        COOKIE_NAME = "girls_kissing";
        SESSION_LIFE_TIME = 604800;
      };
      # }}}

      # Picture and Avatars {{{
      picture = {
        DISABLE_GRAVATAR = false;
        ENABLE_FEDERATED_AVATAR = true;
        AVATAR_MAX_FILE_SIZE = 5242880;
      };
      # }}}
    };

    # Database {{{
    database = {
      type = "postgres";
      host = "127.0.0.1";
      name = "gitea";
      user = "gitea";
      passwordFile = mkSecret "database/pass";
      # just be smarter 4head
      # TODO: setup ensure db in postgres config
      createDatabase = false;
    };
    #}}}

    lfs.enable = true;
  };

  # nginx vhost and anubis definition {{{
  services.anubis.instances."forgejo".settings.TARGET = "http://localhost:${toString config.services.forgejo.settings.server.HTTP_PORT}";
  services.nginx.virtualHosts."patchy.soopy.moe" = _utils.mkSimpleProxy {
    socketPath = config.services.anubis.instances."forgejo".settings.BIND;
    extraConfig.extraConfig = ''
      client_max_body_size 0; # managed by forgejo already, might be useful to quickly fail a request
    '';
  };
  # }}}

  # SSH daemon config {{{
  services.openssh.extraConfig = lib.mkAfter ''
    # forgejo specific settings
    Match User ${config.services.forgejo.user},git
      Banner none
      PasswordAuthentication no
      KbdInteractiveAuthentication no
      AuthorizedKeysCommand ${lib.getExe config.services.forgejo.package} keys -e forgejo -u %u -t %t -k %k -c ${runConfig}
      AuthorizedKeysCommandUser ${config.services.forgejo.user}
  '';
  # }}}
}
# vim:foldmethod=marker

