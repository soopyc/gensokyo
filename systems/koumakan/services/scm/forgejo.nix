{
  pkgs,
  inputs,
  _utils,
  lib,
  config,
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
  replaceSecretBin = "${pkgs.replace-secret}/bin/replace-secret";
in {
  sops.secrets = _utils.genSecrets ns secrets {
    owner = config.services.forgejo.user;
  };
  services.forgejo = {
    enable = true;
    package = inputs.mystia.packages.${pkgs.system}.forgejo-unstable;

    repositoryRoot = "${config.services.forgejo.stateDir}/data/repositories";

    settings = {
      DEFAULT.APP_NAME = "Patchy";
      server = {
        # Basic settings {{{
        PROTOCOL = "http+unix";
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

      # Service {{{
      service = {
        ENABLE_NOTIFY_MAIL = true;
        REGISTER_EMAIL_CONFIRM = true;

        DISABLE_REGISTRATION = false;
        ALLOW_ONLY_EXTERNAL_REGISTRATION = true;

        ENABLE_CAPTCHA = true;
        CAPTCHA_TYPE = "cfturnstile";
        CF_TURNSTILE_SECRET = "#cfturnstile_secret#";
        CF_TURNSTILE_SITEKEY = "#cfturnstile_sitekey#";
      };
      # }}}

      # Mailing {{{
      mailer = {
        ENABLED = true;
        PROTOCOL = "#mailerproto";
        SMTP_ADDR = "#mailerhost#";
        FROM = "#mailerfrom#";
        USER = "#maileruser#";
        PASSWD = "#mailerpass#";
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
        AUTHOR = "Patchy - Git with a touch of knowledge";
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
        ENABLE = true;
        JWT_SIGNING_ALGORITHM = "EdDSA";
        JWT_SIGNING_PRIVATE_KEY_FILE = "jwt/oauth.pem";
        # to generate, we're using: nix run n#openssl -- genpkey -algorithm ed25519 -out /var/lib/forgejo/data/jwt/oauth.pem
      };

      oauth2_client = {
        REGISTER_EMAIL_CONFIRM = false;
      };

      openid = {
        ENABLE_OPENID_SIGNIN = true;
        ENABLE_OPENID_SIGNUP = true;
      };
      # }}}

      # TODO: setup go-camo

      # Logging {{{
      log = {
        ROOT_PATH = "/var/log/forgejo/";
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

  # Systemd jank {{{
  systemd.services.forgejo.preStart = lib.mkAfter ''
    function additional_secrets {
      chmod u+w ${runConfig}
      # replace cf turnstile keys
      ${replaceSecretBin} "#cfturnstile_secret#" ${mkSecret "turnstile/secret"} ${runConfig}
      ${replaceSecretBin} "#cfturnstile_sitekey#" ${mkSecret "turnstile/sitekey"} ${runConfig}

      # to keep stuff in one place, we're not using the mailerPasswordFile option.
      ${replaceSecretBin} "#mailerhost#" ${mkSecret "mailing/host"} ${runConfig}
      ${replaceSecretBin} "#mailerproto#" ${mkSecret "mailing/protocol"} ${runConfig}
      ${replaceSecretBin} "#mailerfrom#" ${mkSecret "mailing/from"} ${runConfig}
      ${replaceSecretBin} "#maileruser#" ${mkSecret "mailing/user"} ${runConfig}
      ${replaceSecretBin} "#mailerpass#" ${mkSecret "mailing/pass"} ${runConfig}
      chmod u-w ${runConfig}
    }
    (umask 027; additional_secrets)
  '';
  # }}}

  # nginx vhost definition {{{
  # since we use unix sockets, we can't use _utils.mkSimpleProxy.
  services.nginx.virtualHosts."patchy.soopy.moe" = _utils.mkVhost {
    locations."/" = {
      proxyPass = "http://unix:${config.services.forgejo.settings.server.HTTP_ADDR}";
    };

    extraConfig = ''
      client_max_body_size 0;  # managed by forgejo already, might be useful to quickly fail a request
    '';
  };
  # }}}

  # SSH daemon config {{{
  services.openssh.extraConfig = lib.mkAfter ''
    # forgejo specific settings
    Match User ${config.services.forgejo.user}
      Banner none
      PasswordAuthentication no
      KbdInteractiveAuthentication no
      AuthorizedKeysCommand ${lib.getExe config.services.forgejo.package} keys -e forgejo -u %u -t %t -k %k -c ${runConfig}
      AuthorizedKeysCommandUser ${config.services.forgejo.user}
  '';
  # }}}
}
# vim:foldmethod=marker

