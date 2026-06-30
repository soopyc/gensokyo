{ _utils, config, ... }:
let
  secrets = _utils.setupSecrets config {
    namespace = "vikunja";
    secrets = [
      "jwt_secret"
      "oauth/cid"
      "oauth/cse"
      "s3/aid"
      "s3/sk"
    ];
  };

  systemdCred = key: { file = "/run/credentials/vikunja/${key}"; };
in
{
  imports = [ secrets.generate ];

  services.vikunja = {
    enable = true;
    port = 35891;

    frontendHostname = "tasks.soopy.moe";
    frontendScheme = "https";

    settings = {
      service = {
        secret = systemdCred "jwt_secret";
        timezone = "Etc/GMT-8"; # is actually UTC+8
        enablepublicteams = true;

        ipextractionmethod = "xff";
        trustedproxies = "127.0.0.1/32";
      };

      auth.local.enabled = false;
      # oauth2
      auth.openid = {
        enabled = true;
        providers.gatekeeper = {
          name = "Gatekeeper";
          authurl = "https://gatekeeper.soopy.moe"; # oidc discovery aware
          clientid = systemdCred "oauth_gatekeeper_cid";
          clientsecret = systemdCred "oauth_gatekeeper_cse";
          scope = "openid profile email";
        };
      };

      files = {
        type = "s3";

        s3 = {
          endpoint = "https://s3.soopy.moe";
          bucket = "vikunja";
          region = "ap-east-1";
          accesskey = systemdCred "s3_aid";
          secretkey = systemdCred "s3_sk";
        };
      };

      avatar.gravatarbaseurl = "https://libravatar.org";
    };
  };

  systemd.services.vikunja.serviceConfig.LoadCredential = [
    "jwt_secret:${secrets.get "jwt_secret"}"
    "oauth_gatekeeper_cid:${secrets.get "oauth/cid"}"
    "oauth_gatekeeper_cse:${secrets.get "oauth/cse"}"
    "s3_aid:${secrets.get "s3/aid"}"
    "s3_sk:${secrets.get "s3/sk"}"
  ];

  services.nginx.virtualHosts."tasks.soopy.moe" = _utils.mkSimpleProxy {
    port = 35891;
  };
}
