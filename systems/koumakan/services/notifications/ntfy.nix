{ _utils, config, ... }:
let
  commonStartupSql = ''
    pragma journal_mode = wal;
  '';
  secrets = _utils.setupSecrets config {
    namespace = "ntfy";
    secrets = [
      "webpush-pk"
      "provision/soopyc"
    ];
  };
in
{
  imports = [
    secrets.generate
    (secrets.mkTemplate "ntfy.env" ''
      NTFY_WEB_PUSH_PRIVATE_KEY=${secrets.placeholder "webpush-pk"}
      NTFY_AUTH_USERS=soopyc:${secrets.placeholder "provision/soopyc"}:admin
    '')
  ];
  services.ntfy-sh = {
    enable = true;
    environmentFile = secrets.getTemplate "ntfy.env";

    settings = {
      base-url = "https://ntfy.soopy.moe";
      listen-unix = "/run/ntfy-sh/ntfy.sock";
      metrics-listen-http = "127.0.0.1:44525";
      behind-proxy = true;
      # listen-http = null; # explode
      listen-unix-mode = 770;

      cache-file = "/var/lib/ntfy-sh/cache.db";
      auth-file = "/var/lib/ntfy-sh/auth.db";
      web-push-file = "/var/lib/ntfy-sh/webpush.db";
      attachment-cache-dir = "/var/lib/ntfy-sh/attachments/";

      auth-startup-queries = commonStartupSql; # why are these manual?
      cache-startup-queries = commonStartupSql;
      web-push-startup-queries = commonStartupSql;

      cache-batch-size = 10;
      cache-batch-timeout = "20s";
      attachment-file-size-limit = "5M";

      global-topic-limit = 1048576;
      message-delay-limit = "7d";

      enable-login = true;
      enable-reservations = true;

      # i wonder why the public key is longer than the private key
      web-push-email-address = "support@soopy.moe";
      web-push-public-key = "BKqcVZJp7zR6wpTvxf0dHT6kTzbLPM_8CwLDMOTpq8SvnbIc1GsOA_LDWP-mxljxJxUd8zd0H_dP1I4EL0puMuk";
      #web-push-private-key set via env vars

      auth-access = [
        "soopyc:gs-*:rw"
        "*:gs-*:ro"
      ];
    };
  };

  services.nginx.virtualHosts."ntfy.soopy.moe" = _utils.mkSimpleProxy {
    socketPath = "/run/ntfy-sh/ntfy.sock";
    websockets = true;
  };

  systemd.services.ntfy-sh.serviceConfig.RuntimeDirectory = "ntfy-sh";
  users.users.nginx.extraGroups = [ config.users.groups.ntfy-sh.name ];
}
