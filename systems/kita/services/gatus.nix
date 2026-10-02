{
  _utils,
  config,
  ...
}:
let
  mkHttpEndpoint = name: group: url: {
    inherit name url group;
    enabled = true;
    method = "GET";
    conditions = [
      "[STATUS] < 300"
      "[CONNECTED] == true"
    ];
    alerts = [
      { type = "ntfy"; }
      { type = "email"; }
    ];
  };

  secrets = _utils.setupSecrets config {
    namespace = "gatus";
    secrets = [
      "ntfy_topic"
      "email/username"
      "email/password"
      "email/dest_addr"
    ];
  };
in
{
  imports = [
    secrets.generate
    (secrets.mkTemplate "gatus.env" ''
      C_NTFY_TOPIC=${secrets.placeholder "ntfy_topic"}
      C_EMAIL_U=${secrets.placeholder "email/username"}
      C_EMAIL_P=${secrets.placeholder "email/password"}
      C_EMAIL_D=${secrets.placeholder "email/dest_addr"}
    '')
  ];

  services.gatus = {
    enable = true;
    settings = {
      storage.type = "sqlite";
      storage.path = "/var/lib/gatus/data.db";
      web.port = 33234;
      ui = {
        title = "Vitals | Gensokyo";
        description = "Gensokyo services electropacketgraph";
        header = "Vitals";
        buttons = [
          {
            name = "Incident Reports";
            link = "https://status.soopy.moe";
          }
        ];
      };

      alerting = {
        ntfy = {
          topic = "\${C_NTFY_TOPIC}";
          url = "https://ntfy.sh";
          priority = 4;
          default-alert = {
            failure-threshold = 3;
            success-threshold = 3;
            send-on-resolved = true;
          };
        };

        email = {
          from = "\${C_EMAIL_U}";
          username = "\${C_EMAIL_U}";
          password = "\${C_EMAIL_P}";
          to = "\${C_EMAIL_D}";
          host = "smtp.soopy.moe";
          port = 465;
          default-alert = {
            failure-threshold = 5;
            success-threshold = 5;
            send-on-resolved = true;
          };
        };
      };

      endpoints = [
        (mkHttpEndpoint "Main Site" "core" "https://soopy.moe")

        (mkHttpEndpoint "Gatekeeper" "koumakan" "https://gatekeeper.soopy.moe")
        (mkHttpEndpoint "Patchy (Forgejo)" "koumakan" "https://patchy.soopy.moe")
        (mkHttpEndpoint "Garage (S3)" "koumakan" "https://s3.soopy.moe/_health")
        (mkHttpEndpoint "Suika (Grafana)" "koumakan" "https://suika.soopy.moe/login")
        (mkHttpEndpoint "Nue (Synapse)" "koumakan" "https://nue.soopy.moe/health")
        (mkHttpEndpoint "Miniflux" "koumakan" "https://flux.soopy.moe")
        (mkHttpEndpoint "Bluesky PDS" "koumakan" "https://bsky.soopy.moe/xrpc/_health")
        (mkHttpEndpoint "Blog (Writefreely)" "koumakan" "https://words.soopy.moe")
        (mkHttpEndpoint "Vaultwarden" "koumakan" "https://v.soopy.moe")
        (mkHttpEndpoint "BreezeWiki" "koumakan" "https://bw.soopy.moe")

        (mkHttpEndpoint "Webmail" "kita" "https://webmail.soopy.moe")
        (mkHttpEndpoint "Radicale" "kita" "https://dav.soopy.moe/.web/")
        {
          enabled = true;
          name = "Maddy";
          group = "kita";
          url = "starttls://mx2.soopy.moe:587";
          interval = "5m";
          conditions = [
            "[CONNECTED] == true"
            "[CERTIFICATE_EXPIRATION] > 10d"
          ];
        }
      ];
    };
  };

  services.nginx.virtualHosts."miku.soopy.moe" = _utils.mkSimpleProxy {
    port = config.services.gatus.settings.web.port;
    extraConfig = {
      useACMEHost = "kita-web.c.soopy.moe";
    };
  };
}
