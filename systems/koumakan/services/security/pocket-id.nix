{
  _utils,
  config,
  # lib,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    namespace = "pocket-id";
    secrets = [ "encryption_key" "maxmind_key" ];
    config = {
      owner = config.users.users.pocket-id.name;
    };
  };
in
{
  imports = [ secrets.generate ];

  services.pocket-id = {
    enable = true;

    settings = {
      PUBLIC_APP_URL = "https://gatekeeper.soopy.moe";
      TRUST_PROXY = true;
      PORT = "31411";
      KEYS_STORAGE = "database";

      ENCRYPTION_KEY_FILE = secrets.get "encryption_key";
      MAXMIND_LICENSE_KEY_FILE = secrets.get "maxmind_key";
    };
  };

  services.nginx.virtualHosts."gatekeeper.soopy.moe" = _utils.mkSimpleProxy {
    port = 31411;
  };
}
