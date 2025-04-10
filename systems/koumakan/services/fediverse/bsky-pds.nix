{
  inputs,
  pkgs,
  config,
  _utils,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    namespace = "pds";
    secrets = [
      "email/address"
      "email/url"
    ];
    config.owner = config.services.bsky-pds.user;
  };
in
{
  imports = [ secrets.generate ];
  services.bsky-pds = {
    enable = true;
    package = inputs.mystia.packages.${pkgs.system}.bsky-pds;

    # because sensible settings are already defined in the module, we can keep this simple :)
    settings = {
      PDS_HOSTNAME = "bsky.soopy.moe";
      PDS_CONTACT_EMAIL_ADDRESS = "me@soopy.moe";
    };
    credentials = {
      PDS_EMAIL_SMTP_URL = secrets.get "email/url";
      PDS_EMAIL_FROM_ADDRESS = secrets.get "email/address";
    };
  };

  services.nginx.virtualHosts.".bsky.soopy.moe" = _utils.mkSimpleProxy {
    port = 2583;
    websockets = true;
    extraConfig = {
      useACMEHost = "bsky.c.soopy.moe";
    };
  };
}
