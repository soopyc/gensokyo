{
  _utils,
  config,
  ...
}: let
  mkHttpEndpoint = name: group: url: {
    inherit name url group;
    enabled = true;
    method = "GET";
    conditions = [
      "[STATUS] < 300"
      "[CONNECTED] == true"
    ];
  };
in {
  services.gatus = {
    enable = true;
    settings = {
      storage.type = "sqlite";
      storage.path = "/var/lib/gatus/data.db";
      web.port = 33234;
      ui = {
        title = "Vitals | Gensokyo";
        description = "Health checking of Gensokyo services, powered by Gatus.";
        header = "Vitals";
        buttons = [
          {
            name = "Incident Reports";
            link = "https://status.soopy.moe";
          }
        ];
      };

      endpoints = [
        (mkHttpEndpoint "Main Site" "core" "https://soopy.moe")

        (mkHttpEndpoint "Gateway (Kanidm)" "koumakan" "https://gateway.soopy.moe" // {enabled = false;}) # TODO
        (mkHttpEndpoint "Patchy (Forgejo)" "koumakan" "https://patchy.soopy.moe")
        (mkHttpEndpoint "Suika (Grafana)" "koumakan" "https://suika.soopy.moe/login")
        (mkHttpEndpoint "Nue (Synapse)" "koumakan" "https://nue.soopy.moe/health")
        (mkHttpEndpoint "Miniflux" "koumakan" "https://flux.soopy.moe")
        (mkHttpEndpoint "Bluesky PDS" "koumakan" "https://bsky.soopy.moe/xrpc/_health")
        (mkHttpEndpoint "Blog (Writefreely)" "koumakan" "https://words.soopy.moe")
        (mkHttpEndpoint "Vaultwarden" "koumakan" "https://v.soopy.moe")

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

        (mkHttpEndpoint "Hydra" "bocchi" "https://hydra.soopy.moe")
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
